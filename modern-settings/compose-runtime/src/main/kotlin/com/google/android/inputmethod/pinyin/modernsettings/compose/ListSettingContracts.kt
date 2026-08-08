package com.google.android.inputmethod.pinyin.modernsettings.compose

data class EnumeratedListContract(
    val key: String,
    val defaultValue: String,
    val values: List<String>,
) {
    fun indexOf(value: String?): Int {
        val index = values.indexOf(value ?: defaultValue)
        require(index >= 0) { "Unsupported value for $key: $value" }
        return index
    }

    fun valueAt(index: Int): String {
        require(index in values.indices) { "Index out of range for $key: $index" }
        return values[index]
    }
}

object ListSettingContracts {
    val pinyinScheme = EnumeratedListContract(
        key = "pinyin_scheme",
        defaultValue = "quanpin",
        values = listOf(
            "quanpin",
            "shuangpin_ms",
            "shuangpin_ziguang",
            "shuangpin_jiajia",
            "shuangpin_abc",
            "shuangpin_ziranma",
            "shuangpin_flypy",
        ),
    )
}
