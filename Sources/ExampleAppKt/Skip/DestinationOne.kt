// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
package example.app

import androidx.compose.runtime.Composable

class DestinationOne: View() {
    fun body(): View {
        return VStackView { listOf(
            TextView("ONE")
                .font("title"),
            NavigationLink("Two", "TWO")
        )}
    }

    // Synthesized
    @Composable
    override fun Compose(context: ComposeContext) {
        body().Compose(context)
    }
}

