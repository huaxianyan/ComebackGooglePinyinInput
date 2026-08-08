package com.google.android.inputmethod.pinyin.modernsettings.compose

internal enum class SettingsRoute {
    Home,
    Input,
    ChineseInput,
    EnglishInput,
    Keyboard,
    KeyboardAppearance,
    KeyboardKeys,
    KeyboardFeedback,
    Handwriting,
    Dictionary,
    Other,
    About,
    FuzzyPinyin,
}

/** Saveable, argument-free route stack for the fixed settings hierarchy. */
internal object SettingsRouteStack {
    const val initialPath: String = "Home"

    fun decode(path: String): List<SettingsRoute> {
        val routes = path.split('/').mapNotNull { name ->
            SettingsRoute.entries.firstOrNull { it.name == name }
        }
        return if (routes.firstOrNull() == SettingsRoute.Home) routes else {
            listOf(SettingsRoute.Home)
        }
    }

    fun current(path: String): SettingsRoute = decode(path).last()

    fun canPop(path: String): Boolean = decode(path).size > 1

    fun push(path: String, destination: SettingsRoute): String {
        require(destination != SettingsRoute.Home)
        return decode(path).joinToString("/") { it.name } + "/" + destination.name
    }

    fun pop(path: String): String {
        val routes = decode(path)
        return if (routes.size <= 1) initialPath
        else routes.dropLast(1).joinToString("/") { it.name }
    }
}
