// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import SkipUI

@available(macOS 13, iOS 16, tvOS 16, watchOS 8, *)
struct DestinationOne : View {
    var body: some View {
        VStack {
            Text("ONE")
                .font(.title)
            NavigationLink(value: "TWO", label: { Text("Two") })
        }
    }
}
