// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import class Foundation.NumberFormatter
public typealias NumberFormatter = Foundation.NumberFormatter
public typealias PlatformNumberFormatter = Foundation.NumberFormatter
public typealias SkipNumberFormatterStyle = NumberFormatter.Style
#else
public typealias NumberFormatter = SkipNumberFormatter
public typealias PlatformNumberFormatter = java.text.DecimalFormat
public typealias SkipNumberFormatterStyle = SkipNumberFormatter.Style
#endif

// SKIP DECLARE: open class SkipNumberFormatter: RawRepresentable<PlatformNumberFormatter>
internal class SkipNumberFormatter : RawRepresentable, Hashable {
    public var rawValue: PlatformNumberFormatter

    public required init(rawValue: PlatformNumberFormatter) {
        self.rawValue = rawValue
    }

    public init(_ rawValue: PlatformNumberFormatter) {
        self.rawValue = rawValue
    }

    public init() {
        #if !SKIP
        self.rawValue = PlatformNumberFormatter()
        #else
        self.rawValue = PlatformNumberFormatter.getIntegerInstance() as PlatformNumberFormatter
        self.groupingSize = 0
        #endif
    }

    #if SKIP
    private var _numberStyle: SkipNumberFormatterStyle = .none
    #endif

    public var description: String {
        return rawValue.description
    }

    public var numberStyle: SkipNumberFormatterStyle {
        get {
            #if !SKIP
            return rawValue.numberStyle
            #else
            return _numberStyle
            #endif
        }

        set {
            #if !SKIP
            rawValue.numberStyle = newValue
            #else
            var fmt: PlatformNumberFormatter = self.rawValue
            switch newValue {
            case .none:
                if let loc = _locale?.rawValue {
                    fmt = PlatformNumberFormatter.getIntegerInstance(loc) as PlatformNumberFormatter
                } else {
                    fmt = PlatformNumberFormatter.getIntegerInstance() as PlatformNumberFormatter
                }
            case .decimal:
                if let loc = _locale?.rawValue {
                    fmt = PlatformNumberFormatter.getNumberInstance(loc) as PlatformNumberFormatter
                } else {
                    fmt = PlatformNumberFormatter.getNumberInstance() as PlatformNumberFormatter
                }
            case .currency:
                if let loc = _locale?.rawValue {
                    fmt = PlatformNumberFormatter.getCurrencyInstance(loc) as PlatformNumberFormatter
                } else {
                    fmt = PlatformNumberFormatter.getCurrencyInstance() as PlatformNumberFormatter
                }
            case .percent:
                if let loc = _locale?.rawValue {
                    fmt = PlatformNumberFormatter.getPercentInstance(loc) as PlatformNumberFormatter
                } else {
                    fmt = PlatformNumberFormatter.getPercentInstance() as PlatformNumberFormatter
                }
            //case .scientific:
            //    fmt = PlatformNumberFormatter.getScientificInstance(loc)
            default:
                fatalError("SkipNumberFormatter: unsupported style \(newValue)")
            }

            let symbols = self.rawValue.decimalFormatSymbols
            if let loc = _locale?.rawValue {
                self.rawValue.applyLocalizedPattern(fmt.toLocalizedPattern())
                symbols.currency = java.util.Currency.getInstance(loc)
                //symbols.currencySymbol = symbols.currency.getSymbol(loc) // also needed or else the sumbol is not applied
            } else {
                self.rawValue.applyPattern(fmt.toPattern())
            }
            self.rawValue.decimalFormatSymbols = symbols
            #endif
        }
    }

    #if SKIP
    private var _locale: SkipLocale? = SkipLocale.current
    #endif

    public var locale: SkipLocale? {
        get {
            #if !SKIP
            return rawValue.locale.flatMap(SkipLocale.init(rawValue:))
            #else
            return _locale
            #endif
        }

        set {
            #if !SKIP
            rawValue.locale = newValue?.rawValue ?? rawValue.locale
            #else
            self._locale = newValue
            if let loc = newValue {
                applySymbol { $0.currency = java.util.Currency.getInstance(loc.rawValue) }
            }
            #endif
        }
    }

    #if os(macOS) || os(Linux) // seems to be unavailable on iOS
    @available(macOS 10.15, macCatalyst 11, *)
    @available(iOS, unavailable, message: "NumberFormatter.format unavailable on iOS")
    @available(watchOS, unavailable, message: "NumberFormatter.format unavailable on watchOS")
    @available(tvOS, unavailable, message: "NumberFormatter.format unavailable on tvOS")
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
    #endif

    public var groupingSize: Int {
        get {
            #if !SKIP
            return rawValue.groupingSize
            #else
            return rawValue.getGroupingSize()
            #endif
        }

        set {
            #if !SKIP
            rawValue.groupingSize = newValue
            #else
            rawValue.setGroupingSize(newValue)
            #endif
        }
    }

    public var generatesDecimalNumbers: Bool {
        get {
            #if !SKIP
            return rawValue.generatesDecimalNumbers
            #else
            return rawValue.isParseBigDecimal()
            #endif
        }

        set {
            #if !SKIP
            rawValue.generatesDecimalNumbers = newValue
            #else
            rawValue.setParseBigDecimal(newValue)
            #endif
        }
    }

    public var alwaysShowsDecimalSeparator: Bool {
        get {
            #if !SKIP
            return rawValue.alwaysShowsDecimalSeparator
            #else
            return rawValue.isDecimalSeparatorAlwaysShown()
            #endif
        }

        set {
            #if !SKIP
            rawValue.alwaysShowsDecimalSeparator = newValue
            #else
            rawValue.setDecimalSeparatorAlwaysShown(newValue)
            #endif
        }
    }

    public var usesGroupingSeparator: Bool {
        get {
            #if !SKIP
            return rawValue.usesGroupingSeparator
            #else
            return rawValue.isGroupingUsed()
            #endif
        }

        set {
            #if !SKIP
            rawValue.usesGroupingSeparator = newValue
            #else
            rawValue.setGroupingUsed(newValue)
            #endif
        }
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
            if let value = newValue {
                rawValue.multiplier = value.intValue
            }
            #endif
        }
    }

    public var groupingSeparator: String? {
        get {
            #if !SKIP
            return rawValue.groupingSeparator
            #else
            return rawValue.decimalFormatSymbols.groupingSeparator.toString()
            #endif
        }

        set {
            #if !SKIP
            rawValue.groupingSeparator = newValue
            #else
            if let groupingSeparator = newValue?.first {
                applySymbol { $0.groupingSeparator = groupingSeparator }
            }
            #endif
        }
    }

    public var percentSymbol: String? {
        get {
            #if !SKIP
            return rawValue.percentSymbol
            #else
            return rawValue.decimalFormatSymbols.percent.toString()
            #endif
        }

        set {
            #if !SKIP
            rawValue.percentSymbol = newValue
            #else
            if let percentSymbol = newValue?.first {
                applySymbol { $0.percent = percentSymbol }
            }
            #endif
        }
    }

    public var currencySymbol: String? {
        get {
            #if !SKIP
            return rawValue.currencySymbol
            #else
            return rawValue.decimalFormatSymbols.currencySymbol
            #endif
        }

        set {
            #if !SKIP
            rawValue.currencySymbol = newValue
            #else
            applySymbol { $0.currencySymbol = newValue }
            #endif
        }
    }

    public var zeroSymbol: String? {
        get {
            #if !SKIP
            return rawValue.zeroSymbol
            #else
            return rawValue.decimalFormatSymbols.zeroDigit?.toString()
            #endif
        }

        set {
            #if !SKIP
            rawValue.zeroSymbol = newValue
            #else
            if let zeroSymbolChar = newValue?.first {
                applySymbol { $0.zeroDigit = zeroSymbolChar }
            }
            #endif
        }
    }

    // no plussign in DecimalFormatSymbols
    //public var plusSign: String? {
    //    get {
    //        #if !SKIP
    //        return rawValue.plusSign
    //        #else
    //        return rawValue.decimalFormatSymbols.plusSign?.toString()
    //        #endif
    //    }
    //
    //    set {
    //        #if !SKIP
    //        rawValue.plusSign = newValue
    //        #else
    //        if let plusSignChar = newValue?.first {
    //            applySymbol { $0.plusSign = plusSignChar }
    //        }
    //        #endif
    //    }
    //}

    public var minusSign: String? {
        get {
            #if !SKIP
            return rawValue.minusSign
            #else
            return rawValue.decimalFormatSymbols.minusSign?.toString()
            #endif
        }

        set {
            #if !SKIP
            rawValue.minusSign = newValue
            #else
            if let minusSignChar = newValue?.first {
                applySymbol { $0.minusSign = minusSignChar }
            }
            #endif
        }
    }

    public var exponentSymbol: String? {
        get {
            #if !SKIP
            return rawValue.exponentSymbol
            #else
            return rawValue.decimalFormatSymbols.exponentSeparator
            #endif
        }

        set {
            #if !SKIP
            rawValue.exponentSymbol = newValue
            #else
            applySymbol { $0.exponentSeparator = newValue }
            #endif
        }
    }

    public var negativeInfinitySymbol: String {
        get {
            #if !SKIP
            return rawValue.negativeInfinitySymbol
            #else
            // Note: java.text.DecimalFormatSymbols has only a single `infinity` compares to `positiveInfinitySymbol` and `negativeInfinitySymbol`
            return rawValue.decimalFormatSymbols.infinity
            #endif
        }

        set {
            #if !SKIP
            rawValue.negativeInfinitySymbol = newValue
            #else
            applySymbol { $0.infinity = newValue }
            #endif
        }
    }

    public var positiveInfinitySymbol: String {
        get {
            #if !SKIP
            return rawValue.positiveInfinitySymbol
            #else
            // Note: java.text.DecimalFormatSymbols has only a single `infinity` compares to `positiveInfinitySymbol` and `negativeInfinitySymbol`
            return rawValue.decimalFormatSymbols.infinity
            #endif
        }

        set {
            #if !SKIP
            rawValue.positiveInfinitySymbol = newValue
            #else
            applySymbol { $0.infinity = newValue }
            #endif
        }
    }

    public var internationalCurrencySymbol: String? {
        get {
            #if !SKIP
            return rawValue.internationalCurrencySymbol
            #else
            return rawValue.decimalFormatSymbols.internationalCurrencySymbol
            #endif
        }

        set {
            #if !SKIP
            rawValue.internationalCurrencySymbol = newValue
            #else
            applySymbol { $0.internationalCurrencySymbol = newValue }
            #endif
        }
    }


    public var decimalSeparator: String? {
        get {
            #if !SKIP
            return rawValue.decimalSeparator
            #else
            return rawValue.decimalFormatSymbols.decimalSeparator?.toString()
            #endif
        }

        set {
            #if !SKIP
            rawValue.decimalSeparator = newValue
            #else
            if let decimalSeparatorChar = newValue?.first {
                applySymbol { $0.decimalSeparator = decimalSeparatorChar }
            }
            #endif
        }
    }

    public var currencyCode: String? {
        get {
            #if !SKIP
            return rawValue.currencyCode
            #else
            return rawValue.decimalFormatSymbols.internationalCurrencySymbol
            #endif
        }

        set {
            #if !SKIP
            rawValue.currencyCode = newValue
            #else
            applySymbol { $0.internationalCurrencySymbol = newValue }
            #endif
        }
    }

    public var currencyDecimalSeparator: String? {
        get {
            #if !SKIP
            return rawValue.currencyDecimalSeparator
            #else
            return rawValue.decimalFormatSymbols.monetaryDecimalSeparator?.toString()
            #endif
        }

        set {
            #if !SKIP
            rawValue.currencyDecimalSeparator = newValue
            #else
            if let currencyDecimalSeparatorChar = newValue?.first {
                applySymbol { $0.monetaryDecimalSeparator = currencyDecimalSeparatorChar }
            }
            #endif
        }
    }

    public var notANumberSymbol: String? {
        get {
            #if !SKIP
            return rawValue.notANumberSymbol
            #else
            return rawValue.decimalFormatSymbols.getNaN()
            #endif
        }

        set {
            #if !SKIP
            rawValue.notANumberSymbol = newValue
            #else
            applySymbol { $0.setNaN(newValue) }
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

    public var minimumFractionDigits: Int {
        get { rawValue.minimumFractionDigits }
        set { rawValue.minimumFractionDigits = newValue }
    }

    public var maximumIntegerDigits: Int {
        get { rawValue.maximumIntegerDigits }
        set { rawValue.maximumIntegerDigits = newValue }
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

    /// Sets the DecimalFormatSymbols with the given block; needed since `getDecimalFormatSymbols` returns a copy, so it must be re-set manually
    private func applySymbol(_ block: (java.text.DecimalFormatSymbols) -> ()) {
        let dfs = rawValue.getDecimalFormatSymbols()
        block(dfs)
        rawValue.setDecimalFormatSymbols(dfs)
    }
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

    public func number(from string: String) -> NSNumber? {
        #if !SKIP
        return rawValue.number(from: string)
        #else
        return rawValue.parse(string) as? NSNumber
        #endif
    }

    public enum Style : Int, @unchecked Sendable {
        case none = 0
        case decimal = 1
        case currency = 2
        case percent = 3
        case scientific = 4
        case spellOut = 5
        // case ordinal = 6 // FIXME: Kotlin error: 47:9 Conflicting declarations: public final val ordinal: Int, enum entry ordinal
        case currencyISOCode = 8
        case currencyPlural = 9
        case currencyAccounting = 10
    }

    public enum PadPosition : Int, @unchecked Sendable {
        case beforePrefix = 0
        case afterPrefix = 1
        case beforeSuffix = 2
        case afterSuffix = 3
    }

    public enum RoundingMode : Int, @unchecked Sendable {
        case ceiling = 0
        case floor = 1
        case down = 2
        case up = 3
        case halfEven = 4
        case halfDown = 5
        case halfUp = 6
    }
}
