// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@_exported import SkipFoundation
@_exported import OSLog
#endif

internal func SkipKitInternalModuleName() -> String {
    return "SkipKit"
}

public func SkipKitPublicModuleName() -> String {
    return "SkipKit"
}
