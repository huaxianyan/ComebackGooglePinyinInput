// Initialized DATrie image operations; Google-derived behavior remains under NOTICE.
#ifndef COMEBACK_RECOVERED_DATRIE_VIEW_H
#define COMEBACK_RECOVERED_DATRIE_VIEW_H

#include <array>
#include <cstddef>
#include <cstdint>
#include <string_view>

namespace comeback::recovered {

class OwnedByteRegion;
using DATrieLabels = std::array<std::uint32_t, 256>;

// Borrowed view of an already-ready trie: separate metadata and writable nodes.
// This does not initialize or load a trie, own readiness, or validate a full image.
// Reacquire the view after either backing region moves or detaches.
class DATrieView {
public:
    DATrieView(const std::uint8_t* metadata, std::size_t metadata_size,
               std::uint8_t* nodes, std::size_t nodes_size)
        : metadata_(metadata), metadata_size_(metadata_size), nodes_(nodes), nodes_size_(nodes_size) {}

    bool AcceptsKey(std::string_view key) const;
    // Root-based lookup returns zero on failure. An empty path returns the root;
    // this alone does not establish that a terminal value exists.
    std::uint32_t FindNode(std::string_view key) const;
    bool UpdateValue(std::string_view key, std::uint32_t value);
    // Node IDs refer to validated terminal cells, not key-path cells.
    bool ReadTerminalValue(std::uint32_t node, std::uint32_t& value) const;
    // Remove a real free cell from its doubly linked chain. Its own words are
    // retained; the native caller must subsequently assign its occupied fields.
    bool UnlinkFreeNode(std::uint32_t node);
    // Return a cell not currently in the ordered chain. Cursor is a preceding
    // chain member or the sentinel; this does not detect duplicate returns.
    bool ReturnFreeNode(std::uint32_t node, std::uint32_t cursor = 0);
    // Emit labels in metadata order, including zero; preserve the unused tail.
    std::size_t EnumerateChildren(std::uint32_t node, DATrieLabels& labels) const;

private:
    friend bool InitializeDATrie(OwnedByteRegion&, OwnedByteRegion&, std::string_view, std::uint8_t);
    friend bool GrowDATrieNodes(OwnedByteRegion&, OwnedByteRegion&);
    friend bool FindDATrieBase(OwnedByteRegion&, OwnedByteRegion&, const std::uint32_t*,
                               std::size_t, std::uint32_t, std::uint32_t&);
    bool AcceptsByte(std::uint8_t byte) const;
    std::uint32_t NodeCount() const;
    std::uint32_t Base(std::uint32_t node) const;
    std::uint32_t Check(std::uint32_t node) const;
    bool IsTerminal(std::uint32_t node) const;
    void WriteBase(std::uint32_t node, std::uint32_t value);
    void WriteCheck(std::uint32_t node, std::uint32_t value);

    const std::uint8_t* metadata_;
    std::size_t metadata_size_;
    std::uint8_t* nodes_;
    std::size_t nodes_size_;
};

// Prepare metadata/alphabet and the initial node chain, then publish both regions.
// The caller owns the enclosing ready state; success makes a view usable.
bool InitializeDATrie(OwnedByteRegion& metadata, OwnedByteRegion& nodes,
                      std::string_view alphabet, std::uint8_t excluded_byte);

// Existing initialized storage only. Growth appends 256 active cells and may
// replace backing storage. Reacquire borrowed views after either operation.
// Sequential failures retain earlier changes; no allocation rollback is added.
bool GrowDATrieNodes(OwnedByteRegion& metadata, OwnedByteRegion& nodes);
// Labels/minimum are bytes in the native alphabet (0..255); the chain is valid
// and ordered. Selection can grow storage but does not reserve the returned base.
bool FindDATrieBase(OwnedByteRegion& metadata, OwnedByteRegion& nodes,
                    const std::uint32_t* labels, std::size_t count,
                    std::uint32_t minimum, std::uint32_t& base);

}  // namespace comeback::recovered
#endif
