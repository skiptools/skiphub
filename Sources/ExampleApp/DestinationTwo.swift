// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import SkipUI

// SKIP INSERT: import androidx.compose.runtime.Composable
// SKIP INSERT: import androidx.compose.foundation.layout.Column

let destinationTwoTitle = "TWO"

// SKIP REPLACE: class DestinationTwo(val title: String = destinationTwoTitle) : View() { @Composable override fun Compose(context: ComposeContext) { body().Compose(context) } }
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
struct DestinationTwo : View {
    let title: String = destinationTwoTitle
}

// SKIP REPLACE: fun DestinationTwo.body() : View { return createTextView().font("title") }
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension DestinationTwo {
    var body: some View {
        createTextView().font(.title)
    }
}

#if SKIP
//typealias VStack = Column
typealias Text = TextView
typealias Button = ButtonView
#else
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
typealias Column = VStack
#endif

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension DestinationTwo {
    func createTextView() -> TextView {
        TextView(title)
    }

    func demoVStack() {
        // SKIP INSERT: @Composable
        func ComposableColumnView() {
            Column {
                Text("One")
                Text("Two")
                Text("Three")
                Text("Four")
                Text("Five")
                Text("Six")
                Text("Seven")
                Text("Eight")
                Text("Nine")
                Text("Ten")
                //Text("Eleven")
            }
        }
    }
}

