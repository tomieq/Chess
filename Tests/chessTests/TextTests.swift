//
//  TextTests.swift
//  
//
//  Created by Tomasz on 07/04/2023.
//

import XCTest
@testable import chess

class TextTests: XCTestCase {
    func test_assigningMultipleVariables() {
        let template = "%@ am %@"
        XCTAssertEqual(template.with("I", "ok"), "I am ok")
    }
}

