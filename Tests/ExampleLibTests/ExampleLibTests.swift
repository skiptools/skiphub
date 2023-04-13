// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if !SKIP
@testable import ExampleLib
#endif
import Foundation
import XCTest
import SkipLib

#if !SKIP
import CryptoKit
#endif

final class ExampleLibTests: XCTestCase {
    func testExampleLib() throws {
        XCTAssertEqual(3.0 + 1.5, 9.0/2)
        XCTAssertEqual("ExampleLib", ExampleLibInternalModuleName())
        XCTAssertEqual("ExampleLib", ExampleLibPublicModuleName())
        XCTAssertEqual("SkipLib", SkipLibPublicModuleName())

        let name = SkipLibPublicModuleName()
        XCTAssertEqual(1, f(f(f(f(f(name))))))

        if false {
            fatalError("XXX")
        }
    }


    private func f(_ string: String) -> Int {
        #if SKIP
        return string.length
        #else
        return string.count
        #endif
    }

    private func f(_ number: Int) -> String {
        return "\(number)"
    }

    func testCryptoHashMD5() {
        let inputData = Data("Hello World".utf8)
        let hashedData: Insecure.MD5Digest = Insecure.MD5.hash(data: inputData)
        XCTAssertEqual("MD5 digest: b10a8db164e0754105b7a99be72e3fe5", hashedData.description)
        XCTAssertEqual("MD5 digest: 5f17026cffec9e27c6657f2f2a54e655", Insecure.MD5.hash(data: Data("ZZ Top".utf8)).description)
    }

    func testCryptoHashSHA1() {
        let inputData = Data("Hello World".utf8)
        let hashedData: Insecure.SHA1Digest = Insecure.SHA1.hash(data: inputData)
        XCTAssertEqual("SHA1 digest: 0a4d55a8d778e5022fab701977c5d840bbc486d0", hashedData.description)
        XCTAssertEqual("SHA1 digest: 962f927d8fb5f84a01d2c7c7a2bdefff151dff09", Insecure.SHA1.hash(data: Data("ZZ Top".utf8)).description)
    }

    func testCryptoHashSHA256() {
        let inputData = Data("Hello World".utf8)
        let hashedData: SHA256Digest = SHA256.hash(data: inputData)
        XCTAssertEqual("SHA256 digest: a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e", hashedData.description)
        XCTAssertEqual("SHA256 digest: db67b0f5582ae32b540e43ab326f582a1f43803e9dfb856206e87b66e3137660", SHA256.hash(data: Data("ZZ Top".utf8)).description)
    }

    func testCryptoHashSHA384() {
        let inputData = Data("Hello World".utf8)
        let hashedData = SHA384.hash(data: inputData)
        XCTAssertEqual("SHA384 digest: 99514329186b2f6ae4a1329e7ee6c610a729636335174ac6b740f9028396fcc803d0e93863a7c3d90f86beee782f4f3f", hashedData.description)
        XCTAssertEqual("SHA384 digest: acfccf00f321f7ae0fcd2352ec0053f06519dcc2084a2b08fb340cce844c0654abf416c23a0ea94483ab2cee21359184", SHA384.hash(data: Data("ZZ Top".utf8)).description)
    }

    func testCryptoHashSHA512() {
        let inputData = Data("Hello World".utf8)
        let hashedData = SHA512.hash(data: inputData)
        XCTAssertEqual("SHA512 digest: 2c74fd17edafd80e8447b0d46741ee243b7eb74dd2149a0ab1b9246fb30382f27e853d8585719e0e67cbda0daa8f51671064615d645ae27acb15bfb1447f459b", hashedData.description)
        XCTAssertEqual("SHA512 digest: 5a293a75e255fbdc85d826483fb1dc05519a750b98e76dfe2922a513df5a4aec2c9daa07cd3abcb0156bdeba3e41897bd0b8f06a3e1df4dd0ec1d0ffefc8abe1", SHA512.hash(data: Data("ZZ Top".utf8)).description)
    }

    func testHMACSignSHA256() {
        let message = "Your message to sign"
        let secret = "your-secret-key"
        let signature = HMAC<SHA256>.authenticationCode(for: Data(message.utf8), using: SymmetricKey(data: Data(secret.utf8)))
        XCTAssertEqual("mUohryR4fJJFBXxnYup30d7IcYsG+o9Oyke/Nz87bfs=", Data(signature).base64EncodedString())
    }

    func testHMACSignSHA1() {
        let message = "Your message to sign"
        let secret = "your-secret-key"
        let signature = HMAC<Insecure.SHA1>.authenticationCode(for: Data(message.utf8), using: SymmetricKey(data: Data(secret.utf8)))
        XCTAssertEqual("6FxBqkItAuJRW8qmco9PnY0gWqY=", Data(signature).base64EncodedString())
    }
}


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

// SKIP INSERT: inline fun <reified T> createAlgorithm(): T { return T::class.java.newInstance() }

public struct HMAC<H> {
    // Kotlin companion objects (static members) do not have access to their declaring type's generics
    //private static func makeAlgorithm() -> H {
        // Cannot use 'H' as reified type parameter. Use a class instead.
        // createAlgorithm()
    //}

    static func authenticationCode(for message: Data, using secret: SymmetricKey) -> PlatformData {
        //let hashName = H.newInstance().hashName
        //let x = createAlgorithm()
        let hashName = "SHA256" // how to get H.digestName?
        let secretKeySpec = javax.crypto.spec.SecretKeySpec(secret.data.rawValue, "Hmac\(hashName)")
        let mac = javax.crypto.Mac.getInstance("Hmac\(hashName)")
        // Skip removes .init because it assumes you want a constructor, so we need to put it back in
        // SKIP REPLACE: mac.init(secretKeySpec)
        mac.init(secretKeySpec)
        let signature = mac.doFinal(message.rawValue)
        return signature
    }
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

