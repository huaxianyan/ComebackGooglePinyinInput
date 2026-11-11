package com.google.android.inputmethod.pinyin.dictsafety;

/**
 * The user dictionaries the safety net watches. One entry per dictionary the keyboard keeps, so a
 * new language is added here and nowhere else.
 */
public enum DictionarySafetyKind {

    CHINESE("bdt", "user_dict_3_3", "dictionary-safety", "dictionary_safety"),
    // English keeps its learned words in the personal dictionary, not in the user dictionary the
    // Chinese engine uses; user_dict_3_3_english is never created by the app.
    ENGLISH("agb", "personal/Personal.en.dict", "dictionary-safety-en", "dictionary_safety_en");

    /** Engine factory class that owns this dictionary. */
    public final String engineFactoryClass;
    /** Dictionary file name inside the app's files directory. */
    public final String fileName;
    /** Private directory that holds this dictionary's snapshots. */
    public final String directoryName;
    /** Private preferences file that holds this dictionary's baseline. */
    public final String preferencesName;

    DictionarySafetyKind(String engineFactoryClass, String fileName, String directoryName,
            String preferencesName) {
        this.engineFactoryClass = engineFactoryClass;
        this.fileName = fileName;
        this.directoryName = directoryName;
        this.preferencesName = preferencesName;
    }
}
