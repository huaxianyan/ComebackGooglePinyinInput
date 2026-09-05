package com.google.android.inputmethod.pinyin.rimesync;

import android.content.ContentResolver;
import android.content.Context;
import android.content.UriPermission;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.provider.DocumentsContract;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

/** SAF access scoped to a Rime synchronization root and one Bridge-owned device directory. */
public final class RimeSyncSafStore {
    public static final int SNAPSHOT_READ_OPEN = 1;
    public static final int SNAPSHOT_READ_PARSE = 2;
    public static final int SNAPSHOT_READ_DATABASE = 3;
    public static final int SNAPSHOT_READ_CLOSE = 4;

    private static final Charset UTF_8 = Charset.forName("UTF-8");
    private static final String MIME_DIRECTORY = DocumentsContract.Document.MIME_TYPE_DIR;

    private final Context context;
    private final ContentResolver resolver;
    private final Uri rootTree;
    private final String rootDocumentId;
    private final RimeSyncConfiguration configuration;

    public RimeSyncSafStore(Context context, Uri rootTree,
            RimeSyncConfiguration configuration) throws IOException {
        if (Build.VERSION.SDK_INT < 21) {
            throw new IOException("Rime synchronization requires Android 5.0 or later");
        }
        if (context == null || rootTree == null || configuration == null
                || !DocumentsContract.isTreeUri(rootTree)) {
            throw new IOException("Rime synchronization root is invalid");
        }
        this.context = context.getApplicationContext();
        this.resolver = this.context.getContentResolver();
        this.rootTree = rootTree;
        this.configuration = configuration;
        try {
            this.rootDocumentId = DocumentsContract.getTreeDocumentId(rootTree);
        } catch (RuntimeException failure) {
            throw new IOException("Rime synchronization root is invalid", failure);
        }
        if (!hasPersistedReadWriteAccess()) {
            throw new IOException("Rime synchronization root permission is unavailable");
        }
    }

    /** Lists one exact configured snapshot from every direct child device directory. */
    public List<SnapshotDocument> listSnapshots() throws IOException {
        recoverBridgeDirectory();
        List<SnapshotDocument> result = new ArrayList<SnapshotDocument>();
        for (DocumentInfo child : listChildren(rootDocumentId)) {
            if (!MIME_DIRECTORY.equals(child.mimeType)) continue;
            DocumentInfo snapshot = findUniqueChild(child.documentId,
                    configuration.snapshotFileName);
            if (snapshot != null) {
                result.add(new SnapshotDocument(child.displayName,
                        documentUri(snapshot.documentId),
                        configuration.deviceDirectoryName.equals(child.displayName)));
            }
        }
        Collections.sort(result, new Comparator<SnapshotDocument>() {
            @Override public int compare(SnapshotDocument left, SnapshotDocument right) {
                return left.deviceDirectoryName.compareTo(right.deviceDirectoryName);
            }
        });
        return result;
    }

    /** Returns the stable identity from the configured Bridge directory, if it exists. */
    public String recoverBridgeUserId() throws IOException {
        DocumentInfo bridge = recoverBridgeDirectory();
        if (bridge == null) return null;
        DocumentInfo snapshot = findUniqueChild(bridge.documentId,
                configuration.snapshotFileName);
        if (snapshot == null) return null;
        RimeUserDbSnapshot existing = readSnapshot(new SnapshotDocument(
                configuration.deviceDirectoryName, documentUri(snapshot.documentId), true));
        return RimeSyncCore.recoverBridgeUserId(existing);
    }

    public RimeUserDbSnapshot readSnapshot(SnapshotDocument document) throws IOException {
        InputStream input = null;
        Reader reader = null;
        try {
            try {
                input = resolver.openInputStream(document.uri);
            } catch (IOException failure) {
                throw new SnapshotReadException(SNAPSHOT_READ_OPEN, failure);
            } catch (RuntimeException failure) {
                throw new SnapshotReadException(SNAPSHOT_READ_OPEN, failure);
            }
            if (input == null) {
                throw new SnapshotReadException(SNAPSHOT_READ_OPEN, null);
            }
            reader = new InputStreamReader(input, UTF_8);
            RimeUserDbSnapshot snapshot;
            try {
                snapshot = RimeUserDbSnapshot.read(reader);
            } catch (IOException failure) {
                throw new SnapshotReadException(SNAPSHOT_READ_PARSE, failure);
            }
            try {
                RimeSyncCore.normalizeSnapshotDatabase(snapshot, configuration,
                        document.bridgeOwned);
            } catch (IOException failure) {
                throw new SnapshotReadException(SNAPSHOT_READ_DATABASE, failure);
            }
            try {
                reader.close();
            } catch (IOException failure) {
                throw new SnapshotReadException(SNAPSHOT_READ_CLOSE, failure);
            }
            reader = null;
            input = null;
            return snapshot;
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException ignored) {
                }
            } else if (input != null) {
                try {
                    input.close();
                } catch (IOException ignored) {
                }
            }
        }
    }

    /** Publishes a validated full snapshot and leaves a recoverable old version during replacement. */
    public void publish(RimeUserDbSnapshot snapshot, String expectedBridgeUserId)
            throws IOException {
        if (snapshot == null || !configuration.databaseName.equals(snapshot.dbName())
                || !expectedBridgeUserId.equals(snapshot.metadata().get("user_id"))) {
            throw new IOException("Bridge snapshot identity is invalid");
        }
        DocumentInfo bridge = ensureBridgeDirectory();
        recoverPublishedFile(bridge.documentId);
        String temporaryName = "." + configuration.snapshotFileName + ".bridge-"
                + UUID.randomUUID().toString() + ".partial.txt";
        Uri temporary = createFile(bridge.documentId, temporaryName);
        Uri previous = null;
        try {
            writeSnapshot(temporary, snapshot);
            SnapshotDocument check = new SnapshotDocument(configuration.deviceDirectoryName,
                    temporary, true);
            RimeUserDbSnapshot validated = readSnapshot(check);
            if (!expectedBridgeUserId.equals(validated.metadata().get("user_id"))) {
                throw new IOException("published Bridge snapshot changed during validation");
            }

            DocumentInfo current = findUniqueChild(bridge.documentId,
                    configuration.snapshotFileName);
            DocumentInfo stalePrevious = findUniqueChild(bridge.documentId, previousName());
            if (stalePrevious != null) delete(documentUri(stalePrevious.documentId));
            if (current != null) {
                previous = rename(documentUri(current.documentId), previousName());
            }
            Uri published;
            try {
                published = rename(temporary, configuration.snapshotFileName);
                temporary = null;
            } catch (IOException failure) {
                if (previous != null) {
                    rename(previous, configuration.snapshotFileName);
                    previous = null;
                }
                throw failure;
            }
            verifyDisplayName(published, configuration.snapshotFileName);
            if (previous != null) {
                delete(previous);
                previous = null;
            }
        } finally {
            if (temporary != null) deleteQuietly(temporary);
        }
    }

    /** Returns the Bridge directory after repairing an interrupted fixed-name replacement. */
    public DocumentInfo recoverBridgeDirectory() throws IOException {
        DocumentInfo bridge = findUniqueChild(rootDocumentId,
                configuration.deviceDirectoryName);
        if (bridge == null) return null;
        if (!MIME_DIRECTORY.equals(bridge.mimeType)) {
            throw new IOException("configured Bridge device name is not a directory");
        }
        recoverPublishedFile(bridge.documentId);
        return bridge;
    }

    private DocumentInfo ensureBridgeDirectory() throws IOException {
        DocumentInfo existing = recoverBridgeDirectory();
        if (existing != null) return existing;
        Uri root = documentUri(rootDocumentId);
        Uri created;
        try {
            created = DocumentsContract.createDocument(resolver, root, MIME_DIRECTORY,
                    configuration.deviceDirectoryName);
        } catch (RuntimeException failure) {
            throw new IOException("Bridge device directory could not be created", failure);
        }
        if (created == null) throw new IOException("Bridge device directory could not be created");
        verifyDisplayName(created, configuration.deviceDirectoryName);
        DocumentInfo verified = findUniqueChild(rootDocumentId,
                configuration.deviceDirectoryName);
        if (verified == null || !MIME_DIRECTORY.equals(verified.mimeType)) {
            throw new IOException("created Bridge device directory is not a direct child");
        }
        return verified;
    }

    private void recoverPublishedFile(String bridgeDocumentId) throws IOException {
        List<DocumentInfo> children = listChildren(bridgeDocumentId);
        DocumentInfo current = uniqueNamed(children, configuration.snapshotFileName);
        DocumentInfo previous = uniqueNamed(children, previousName());
        for (DocumentInfo child : children) {
            if (child.displayName.startsWith("." + configuration.snapshotFileName + ".bridge-")
                    && (child.displayName.endsWith(".partial")
                            || child.displayName.endsWith(".partial.txt"))) {
                deleteQuietly(documentUri(child.documentId));
            }
        }
        if (current == null && previous != null) {
            rename(documentUri(previous.documentId), configuration.snapshotFileName);
        } else if (current != null && previous != null) {
            delete(documentUri(previous.documentId));
        }
    }

    private void writeSnapshot(Uri target, RimeUserDbSnapshot snapshot) throws IOException {
        OutputStream output = null;
        OutputStreamWriter writer = null;
        try {
            output = resolver.openOutputStream(target, "w");
            if (output == null) throw new IOException("Bridge snapshot could not be written");
            writer = new OutputStreamWriter(output, UTF_8);
            snapshot.write(writer);
        } finally {
            if (writer != null) writer.close();
            else if (output != null) output.close();
        }
    }

    private Uri createFile(String parentDocumentId, String name) throws IOException {
        try {
            Uri created = DocumentsContract.createDocument(resolver, documentUri(parentDocumentId),
                    "text/plain", name);
            if (created == null) throw new IOException("Bridge temporary snapshot was not created");
            verifyDisplayName(created, name);
            return created;
        } catch (RuntimeException failure) {
            throw new IOException("Bridge temporary snapshot was not created", failure);
        }
    }

    private Uri rename(Uri document, String name) throws IOException {
        try {
            Uri renamed = DocumentsContract.renameDocument(resolver, document, name);
            if (renamed == null) throw new IOException("Rime snapshot rename failed");
            verifyDisplayName(renamed, name);
            return renamed;
        } catch (RuntimeException failure) {
            throw new IOException("Rime snapshot rename failed", failure);
        }
    }

    private void delete(Uri document) throws IOException {
        try {
            if (!DocumentsContract.deleteDocument(resolver, document)) {
                throw new IOException("Rime snapshot cleanup failed");
            }
        } catch (RuntimeException failure) {
            throw new IOException("Rime snapshot cleanup failed", failure);
        }
    }

    private void deleteQuietly(Uri document) {
        try {
            DocumentsContract.deleteDocument(resolver, document);
        } catch (Exception ignored) {
        }
    }

    private DocumentInfo findUniqueChild(String parentDocumentId, String name)
            throws IOException {
        return uniqueNamed(listChildren(parentDocumentId), name);
    }

    private static DocumentInfo uniqueNamed(List<DocumentInfo> children, String name)
            throws IOException {
        DocumentInfo result = null;
        for (DocumentInfo child : children) {
            if (!name.equals(child.displayName)) continue;
            if (result != null) throw new IOException("duplicate Rime document name");
            result = child;
        }
        return result;
    }

    private List<DocumentInfo> listChildren(String parentDocumentId) throws IOException {
        List<DocumentInfo> result = new ArrayList<DocumentInfo>();
        Cursor cursor = null;
        try {
            Uri children = DocumentsContract.buildChildDocumentsUriUsingTree(
                    rootTree, parentDocumentId);
            cursor = resolver.query(children, new String[] {
                    DocumentsContract.Document.COLUMN_DOCUMENT_ID,
                    DocumentsContract.Document.COLUMN_DISPLAY_NAME,
                    DocumentsContract.Document.COLUMN_MIME_TYPE
            }, null, null, null);
            if (cursor == null) throw new IOException("Rime directory could not be listed");
            while (cursor.moveToNext()) {
                String id = cursor.getString(0);
                String name = cursor.getString(1);
                String mime = cursor.getString(2);
                if (id == null || name == null || mime == null) {
                    throw new IOException("Rime directory contains incomplete metadata");
                }
                result.add(new DocumentInfo(id, name, mime));
            }
        } catch (RuntimeException failure) {
            throw new IOException("Rime directory could not be listed", failure);
        } finally {
            if (cursor != null) cursor.close();
        }
        return result;
    }

    private Uri documentUri(String documentId) {
        return DocumentsContract.buildDocumentUriUsingTree(rootTree, documentId);
    }

    private void verifyDisplayName(Uri document, String expected) throws IOException {
        Cursor cursor = null;
        try {
            cursor = resolver.query(document,
                    new String[] {DocumentsContract.Document.COLUMN_DISPLAY_NAME},
                    null, null, null);
            if (cursor == null || !cursor.moveToFirst() || !expected.equals(cursor.getString(0))) {
                throw new IOException("document provider changed the requested Rime name");
            }
        } catch (RuntimeException failure) {
            throw new IOException("Rime document identity could not be verified", failure);
        } finally {
            if (cursor != null) cursor.close();
        }
    }

    private boolean hasPersistedReadWriteAccess() {
        try {
            for (UriPermission permission : resolver.getPersistedUriPermissions()) {
                if (rootTree.equals(permission.getUri()) && permission.isReadPermission()
                        && permission.isWritePermission()) return true;
            }
        } catch (RuntimeException ignored) {
        }
        return false;
    }

    private String previousName() {
        return "." + configuration.snapshotFileName + ".bridge-previous.txt";
    }

    public static final class SnapshotReadException extends IOException {
        public final int kind;

        SnapshotReadException(int kind, Throwable cause) {
            super("Rime snapshot could not be read", cause);
            this.kind = kind;
        }
    }

    public static final class SnapshotDocument {
        public final String deviceDirectoryName;
        public final Uri uri;
        public final boolean bridgeOwned;

        SnapshotDocument(String deviceDirectoryName, Uri uri, boolean bridgeOwned) {
            this.deviceDirectoryName = deviceDirectoryName;
            this.uri = uri;
            this.bridgeOwned = bridgeOwned;
        }
    }

    public static final class DocumentInfo {
        public final String documentId;
        public final String displayName;
        public final String mimeType;

        DocumentInfo(String documentId, String displayName, String mimeType) {
            this.documentId = documentId;
            this.displayName = displayName;
            this.mimeType = mimeType;
        }
    }
}
