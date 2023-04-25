// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest
#if !SKIP
@testable import SkipFoundation
#endif

// Stand-in types for test case compilation

#if SKIP
internal class NSObject {
}

//internal class NSString : NSObject {
//}
//
//internal class NSMutableString : NSString {
//}


internal class NSData : NSObject {
}

internal class NSMutableData : NSData {
}

internal struct AttributedString {
}

internal class NSAttributedString : NSObject {
}

internal class NSMutableAttributedString : NSAttributedString {

}


#endif
