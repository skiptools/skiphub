// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.NumberFormatter
public typealias NumberFormatter = Foundation.NumberFormatter
public typealias PlatformNumberFormatter = Foundation.NumberFormatter
#else
public typealias NumberFormatter = SkipNumberFormatter
public typealias PlatformNumberFormatter = java.text.DecimalFormat
#endif

public struct SkipNumberFormatter : RawRepresentable, Hashable {
    public var rawValue: PlatformNumberFormatter

    public init(rawValue: PlatformNumberFormatter) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformNumberFormatter) {
        self.rawValue = rawValue
    }

    public init() {
        self.rawValue = PlatformNumberFormatter()
        self.maximumFractionDigits = 0
    }

    public var format: String {
        get {
            #if !SKIP
            return rawValue.format
            #else
            return rawValue.toPattern()
            #endif
        }

        set {
            #if !SKIP
            rawValue.format = newValue
            #else
            rawValue.applyPattern(newValue)
            #endif
        }
    }

    public var description: String {
        return rawValue.description
    }


    public var multiplier: NSNumber? {
        get {
            #if !SKIP
            return rawValue.multiplier
            #else
            return rawValue.multiplier as NSNumber
            #endif
        }

        set {
            #if !SKIP
            rawValue.multiplier = newValue
            #else
            rawValue.multiplier = newValue?.intValue ?? 1
            #endif
        }
    }

    public var positiveSuffix: String? {
        get { rawValue.positiveSuffix }
        set { rawValue.positiveSuffix = newValue }
    }

    public var negativeSuffix: String? {
        get { rawValue.negativeSuffix }
        set { rawValue.negativeSuffix = newValue }
    }

    public var positivePrefix: String? {
        get { rawValue.positivePrefix }
        set { rawValue.positivePrefix = newValue }
    }

    public var negativePrefix: String? {
        get { rawValue.negativePrefix }
        set { rawValue.negativePrefix = newValue }
    }

    public var maximumFractionDigits: Int {
        get { rawValue.maximumFractionDigits }
        set { rawValue.maximumFractionDigits = newValue }
    }

    public var minimumIntegerDigits: Int {
        get { rawValue.minimumIntegerDigits }
        set { rawValue.minimumIntegerDigits = newValue }
    }

    public func string(from number: NSNumber) -> String? {
        #if !SKIP
        return rawValue.string(from: number)
        #else
        return rawValue.format(number)
        #endif
    }

    #if SKIP
    public func string(from number: Int) -> String? { string(from: number as NSNumber) }
    public func string(from number: Double) -> String? { string(from: number as NSNumber) }
    #endif

    public func string(for object: Any?) -> String? {
        #if !SKIP
        return rawValue.string(for: object)
        #else
        if let number = object as? NSNumber {
            return string(from: number)
        } else if let bool = object as? Bool {
            // this is the expected NSNumber behavior checked in test_stringFor
            return string(from: bool == true ? 1 : 0)
        } else {
            return nil
        }
        #endif
    }
}
