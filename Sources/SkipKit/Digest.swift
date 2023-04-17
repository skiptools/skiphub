// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import SkipFoundation

#if !SKIP
@_exported import CryptoKit
#endif

#if !SKIP
/// An alias for `HMAC<Insecure.MD5>` since Kotlin does not support static access to generics
typealias HMACMD5 = HMAC<Insecure.MD5>
/// An alias for `HMAC<Insecure.SHA1>` since Kotlin does not support static access to generics
typealias HMACSHA1 = HMAC<Insecure.SHA1>
/// An alias for `HMAC<SHA256>` since Kotlin does not support static access to generics
typealias HMACSHA256 = HMAC<SHA256>
/// An alias for `HMAC<SHA384>` since Kotlin does not support static access to generics
typealias HMACSHA384 = HMAC<SHA384>
/// An alias for `HMAC<SHA512>` since Kotlin does not support static access to generics
typealias HMACSHA512 = HMAC<SHA512>
#else

open class DigestFunction {
    static var hashName: String = ""

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

#endif

#if SKIP

/// Implemented as a simple Data wrapper
public struct SymmetricKey {
    let data: Data
}

public extension Data {
    /// Convert the bytes into a base64 string
    public func base64EncodedString() -> String {
        return java.util.Base64.getEncoder().encodeToString(rawValue)
    }

    /// Convert the bytes into a hex string
    public func hex() -> String {
        rawValue.hex()
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
    public let digest = MessageDigest.getInstance("SHA-256")
    public let digestName = "SHA256"

    public static func hash(data: Data) -> SHA256Digest {
        return SHA256Digest(rawValue: SHA256().digest.digest(data.rawValue))
    }
}

public struct SHA256Digest : Digest {
    let rawValue: PlatformData

    var description: String {
        "SHA256 digest: " + rawValue.hex()
    }
}

public struct SHA384 : NamedHashFunction {
    typealias Digest = SHA384Digest
    public let digest = MessageDigest.getInstance("SHA-384")
    public let digestName = "SHA384"

    public static func hash(data: Data) -> SHA384Digest {
        return SHA384Digest(rawValue: SHA384().digest.digest(data.rawValue))
    }
}

public struct SHA384Digest : Digest {
    let rawValue: PlatformData

    var description: String {
        "SHA384 digest: " + rawValue.hex()
    }
}

public struct SHA512 : NamedHashFunction {
    typealias Digest = SHA512Digest
    public let digest = MessageDigest.getInstance("SHA-512")
    public let digestName = "SHA"

    public static func hash(data: Data) -> SHA512Digest {
        return SHA512Digest(rawValue: SHA512().digest.digest(data.rawValue))
    }
}

public struct SHA512Digest : Digest {
    let rawValue: PlatformData

    var description: String {
        "SHA512 digest: " + rawValue.hex()
    }
}

public struct Insecure {
    public struct MD5 : NamedHashFunction {
        typealias Digest = MD5Digest
        public let digest = MessageDigest.getInstance("MD5")
        public let digestName = "MD5"

        public static func hash(data: Data) -> MD5Digest {
            return MD5Digest(rawValue: MD5().digest.digest(data.rawValue))
        }
    }

    public struct MD5Digest : Digest {
        let rawValue: PlatformData

        var description: String {
            "MD5 digest: " + rawValue.hex()
        }
    }

    public struct SHA1 : NamedHashFunction {
        typealias Digest = SHA1Digest
        public let digest = MessageDigest.getInstance("SHA1")
        public let digestName = "SHA1"

        public static func hash(data: Data) -> SHA1Digest {
            return SHA1Digest(rawValue: SHA1().digest.digest(data.rawValue))
        }
    }

    public struct SHA1Digest : Digest {
        let rawValue: PlatformData

        var description: String {
            "SHA1 digest: " + rawValue.hex()
        }
    }
}

extension String {
    public var utf8: PlatformData {
        return toByteArray(java.nio.charset.StandardCharsets.UTF_8)
    }

    public var utf16: PlatformData {
        return toByteArray(java.nio.charset.StandardCharsets.UTF_16)
    }
}

#endif
