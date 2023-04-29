// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
import struct Foundation.UUID
public typealias UUID = Foundation.UUID
internal typealias PlatformUUID = Foundation.UUID
#else
public typealias UUID = SkipUUID
public typealias PlatformUUID = java.util.UUID
#endif

#if SKIP
public func UUID(uuidString: String) -> SkipUUID? {
    // Java throws an exception for bad UUID, but Foundation expects it to return nil
    guard let uuid = try? java.util.UUID.fromString(uuidString) else { return nil }
    return SkipUUID(rawValue: uuid)
}
#endif

// SKIP DECLARE: class SkipUUID: RawRepresentable<PlatformUUID>, MutableStruct
internal struct SkipUUID : RawRepresentable, Hashable, CustomStringConvertible {
    public var rawValue: PlatformUUID

    public init(_ rawValue: PlatformUUID) {
        self.rawValue = rawValue
    }

    #if !SKIP
    public init(rawValue: PlatformUUID) {
        self.rawValue = rawValue
    }
    #endif

    #if SKIP
    public init() {
        self.rawValue = java.util.UUID.randomUUID()
    }
    #endif

    #if SKIP
    public static func fromString(uuidString: String) -> SkipUUID? {
        // Java throws an exception for bad UUID, but Foundation expects it to return nil
        // return try? SkipUUID(rawValue: PlatformUUID.fromString(uuidString)) // mistranspiles to: (PlatformUUID.companionObjectInstance as java.util.UUID.Companion).fromString(uuidString))
        return try? SkipUUID(rawValue: java.util.UUID.fromString(uuidString))
    }
    #endif

    #if SKIP
    // Kotlin does not support constructors that return nil. Consider creating a factory function
//    init?(uuidString: String) {
//        self.rawValue = java.util.UUID.fromString(uuidString)
//    }
    #endif

    public var uuidString: String {
        #if SKIP
        // java.util.UUID is lowercase, Foundation.UUID is uppercase
        return rawValue.toString().uppercase()
        #else
        return rawValue.uuidString
        #endif
    }

    public var description: String {
        return uuidString
    }
}

#if !SKIP

extension UUID {
    /// Creates this UUID using the given most signifant bits and least significant bits.
    @inlinable public init(mostSigBits: Int64, leastSigBits: Int64) {
        var mostSigBits = mostSigBits
        var leastSigBits = leastSigBits
        self = withUnsafeBytes(of: &mostSigBits) { a in
            withUnsafeBytes(of: &leastSigBits) { b in
                UUID(uuid: (a[7], a[6], a[5], a[4], a[3], a[2], a[1], a[0], b[7], b[6], b[5], b[4], b[3], b[2], b[1], b[0]))
            }
        }
    }
}

#else

// SKIP INSERT: public fun UUID(mostSigBits: Long, leastSigBits: Long): SkipUUID { return SkipUUID(PlatformUUID(mostSigBits, leastSigBits)) }

extension SkipUUID {

    // TODO: constructor support (remove SKIP INSERT above)
//    public init(mostSigBits: Int64, leastSigBits: Int64) {
//        SkipUUID(mostSigBits, leastSigBits)
//    }

//    public var uuidString: String {
//        // java.util.UUID is lowercase, Foundation.UUID is uppercase
//        return rawValue.toString().uppercase()
//    }
//
//    public var description: String {
//        return uuidString
//    }
}

#endif
