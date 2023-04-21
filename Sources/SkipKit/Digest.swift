// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import SkipFoundation

#if !SKIP
@_exported import CryptoKit

/// An alias for `HMAC<Insecure.MD5>` since Kotlin does not support static access to generics
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public typealias HMACMD5 = HMAC<Insecure.MD5>
/// An alias for `HMAC<Insecure.SHA1>` since Kotlin does not support static access to generics
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public typealias HMACSHA1 = HMAC<Insecure.SHA1>
/// An alias for `HMAC<SHA256>` since Kotlin does not support static access to generics
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public typealias HMACSHA256 = HMAC<SHA256>
/// An alias for `HMAC<SHA384>` since Kotlin does not support static access to generics
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public typealias HMACSHA384 = HMAC<SHA384>
/// An alias for `HMAC<SHA512>` since Kotlin does not support static access to generics
@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
public typealias HMACSHA512 = HMAC<SHA512>


@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension String {
    /// Returns the underlying UTF-8 data for this string
    @inlinable public var utf8Data: Data {
        Data(utf8)
    }
}

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension DataProtocol {
    public func sha256() -> ContiguousBytes {
        SHA256.hash(data: self)
    }
}

//extension ContiguousBytes {
//    public func sha256() -> ContiguousBytes {
//        withUnsafeBytes {
//            SHA256.hash(data: Data($0))
//        }
//    }
//}

@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
extension ContiguousBytes {
    /// Returns the contents of the Data as a hex string
    /// - Parameter uppercase: whether to return the hex string with uppercase characters
    public func hex(upperCase: Bool = false) -> String {
        let hexDigits = upperCase ? "0123456789ABCDEF" : "0123456789abcdef"
        let utf8Digits = Array(hexDigits.utf8)

        return withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> String in
            let buffer = bytes.bindMemory(to: UInt8.self)
            return String(unsafeUninitializedCapacity: 2 * buffer.count) { (ptr) -> Int in
                var p = ptr.baseAddress!
                for byte in buffer {
                    p[0] = utf8Digits[Int(byte / 16)]
                    p[1] = utf8Digits[Int(byte % 16)]
                    p += 2
                }
                return 2 * buffer.count
            }
        }
    }
}

#else

open class DigestFunction {
    static func authenticationCode(for message: Data, using secret: SymmetricKey, algorithm hashName: String) -> PlatformData {
        let secretKeySpec = javax.crypto.spec.SecretKeySpec(secret.data.rawValue, "Hmac\(hashName)")
        let mac = javax.crypto.Mac.getInstance("Hmac\(hashName)")
        // Skip removes .init because it assumes you want a constructor, so we need to put it back in
        // SKIP REPLACE: mac.init(secretKeySpec)
        mac.init(secretKeySpec)
        let signature = mac.doFinal(message.rawValue)
        return signature
    }
}


open class HMACMD5 : DigestFunction {
    public static func authenticationCode(for message: Data, using secret: SymmetricKey) -> PlatformData {
        DigestFunction.authenticationCode(for: message, using: secret, algorithm: "MD5")
    }
}

open class HMACSHA1 : DigestFunction {
    public static func authenticationCode(for message: Data, using secret: SymmetricKey) -> PlatformData {
        DigestFunction.authenticationCode(for: message, using: secret, algorithm: "SHA1")
    }
}

open class HMACSHA256 : DigestFunction {
    public static func authenticationCode(for message: Data, using secret: SymmetricKey) -> PlatformData {
        DigestFunction.authenticationCode(for: message, using: secret, algorithm: "SHA256")
    }
}

open class HMACSHA384 : DigestFunction {
    public static func authenticationCode(for message: Data, using secret: SymmetricKey) -> PlatformData {
        DigestFunction.authenticationCode(for: message, using: secret, algorithm: "SHA384")
    }
}

open class HMACSHA512 : DigestFunction {
    public static func authenticationCode(for message: Data, using secret: SymmetricKey) -> PlatformData {
        DigestFunction.authenticationCode(for: message, using: secret, algorithm: "SHA512")
    }
}


/// Implemented as a simple Data wrapper
public struct SymmetricKey {
    let data: Data
}

extension Data {
    /// Convert the bytes into a base64 string
    public func base64EncodedString() -> String {
        return java.util.Base64.getEncoder().encodeToString(rawValue)
    }

    /// Convert the bytes into a hex string
    public func sha256() -> Data {
        Data(SHA256.hash(data: self).bytes)
    }

    /// Convert the bytes into a hex string
    public func hex(upperCase: Bool = false) -> String {
        if upperCase {
            return rawValue.hex().toUpperCase()
        } else {
            return rawValue.hex()
        }
    }
}

public extension PlatformData {
    /// Convert the bytes into a hex string
    public func hex() -> String {
        joinToString("") {
            java.lang.Byte.toUnsignedInt($0).toString(radix: 16).padStart(2, "0".get(0))
        }
    }
}

public typealias MessageDigest = java.security.MessageDigest

public protocol HashFunction {
    //static var blockByteCount: Int { get }
    associatedtype Digest // : Digest
    //init()
    //mutating func update(bufferPointer: UnsafeRawBufferPointer)
    //func finalize() -> Self.Digest
}

public protocol Digest {
}

public protocol NamedHashFunction : HashFunction {
    var digest: MessageDigest { get }
    var digestName: String { get } // Kotlin does not support static members in protocols
    //func createMessageDigest() throws -> MessageDigest
}

public struct SHA256 : NamedHashFunction {
    typealias Digest = SHA256Digest
    public let digest: MessageDigest = MessageDigest.getInstance("SHA-256")
    public let digestName = "SHA256"

    public static func hash(data: Data) -> SHA256Digest {
        return SHA256Digest(bytes: SHA256().digest.digest(data.rawValue))
    }
}

public struct SHA256Digest : Digest {
    let bytes: PlatformData

    var description: String {
        "SHA256 digest: " + bytes.hex()
    }
}

public struct SHA384 : NamedHashFunction {
    typealias Digest = SHA384Digest
    public let digest: MessageDigest = MessageDigest.getInstance("SHA-384")
    public let digestName = "SHA384"

    public static func hash(data: Data) -> SHA384Digest {
        return SHA384Digest(bytes: SHA384().digest.digest(data.rawValue))
    }
}

public struct SHA384Digest : Digest {
    let bytes: PlatformData

    var description: String {
        "SHA384 digest: " + bytes.hex()
    }
}

public struct SHA512 : NamedHashFunction {
    typealias Digest = SHA512Digest
    public let digest: MessageDigest = MessageDigest.getInstance("SHA-512")
    public let digestName = "SHA"

    public static func hash(data: Data) -> SHA512Digest {
        return SHA512Digest(bytes: SHA512().digest.digest(data.rawValue))
    }
}

public struct SHA512Digest : Digest {
    let bytes: PlatformData

    var description: String {
        "SHA512 digest: " + bytes.hex()
    }
}

public struct Insecure {
    public struct MD5 : NamedHashFunction {
        typealias Digest = MD5Digest
        public let digest: MessageDigest = MessageDigest.getInstance("MD5")
        public let digestName = "MD5"

        public static func hash(data: Data) -> MD5Digest {
            return MD5Digest(bytes: MD5().digest.digest(data.rawValue))
        }
    }

    public struct MD5Digest : Digest {
        let bytes: PlatformData

        var description: String {
            "MD5 digest: " + bytes.hex()
        }
    }

    public struct SHA1 : NamedHashFunction {
        typealias Digest = SHA1Digest
        public let digest: MessageDigest = MessageDigest.getInstance("SHA1")
        public let digestName = "SHA1"

        public static func hash(data: Data) -> SHA1Digest {
            return SHA1Digest(bytes: SHA1().digest.digest(data.rawValue))
        }
    }

    public struct SHA1Digest : Digest {
        let bytes: PlatformData

        var description: String {
            "SHA1 digest: " + bytes.hex()
        }
    }
}

extension String {
    public var utf8Data: Data {
        return Data(utf8)
    }

    public var utf8: PlatformData {
        return toByteArray(java.nio.charset.StandardCharsets.UTF_8)
    }

    public var utf16: PlatformData {
        return toByteArray(java.nio.charset.StandardCharsets.UTF_16)
    }
}

#endif
