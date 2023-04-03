// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@_exported import SkipFoundation
import SwiftUI

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias App = SwiftUI.App
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias Scene = SwiftUI.Scene
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias WindowGroup = SwiftUI.WindowGroup

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias View = SwiftUI.View
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias State = SwiftUI.State
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias Binding = SwiftUI.Binding
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias ObservableObject = SwiftUI.ObservableObject
@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias EnvironmentObject = SwiftUI.EnvironmentObject

//@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
//public typealias ForEach = SwiftUI.ForEach

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias HStack = SwiftUI.HStack

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias VStack = SwiftUI.VStack

//@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
//public typealias Rectangle = SwiftUI.Rectangle

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias Text = SwiftUI.Text

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias Label = SwiftUI.Label

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias Color = SwiftUI.Color

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias Button = SwiftUI.Button

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias TabView = SwiftUI.TabView

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias TextField = SwiftUI.TextField


@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias Published = SwiftUI.Published

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
public typealias StateObject = SwiftUI.StateObject


@available(macOS 13, iOS 16, tvOS 16, watchOS 8, *)
public typealias NavigationLink = SwiftUI.NavigationLink

@available(macOS 13, iOS 16, tvOS 16, watchOS 8, *)
public typealias NavigationStack = SwiftUI.NavigationStack

#endif

internal func SkipUIInternalModuleName() -> String {
    return "SkipUI"
}

public func SkipUIPublicModuleName() -> String {
    return "SkipUI"
}
