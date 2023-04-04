//
//  ChessPieceTypeTests.swift
//
//
//  Created by Tomasz on 04/04/2023.
//

import XCTest
@testable import chess

class ChessPieceTypeTests: XCTestCase {
    func test_creatingTypeFromPolishLetter() {
        XCTAssertEqual(ChessPieceType.make(pl: "K"), .king)
        XCTAssertEqual(ChessPieceType.make(pl: "H"), .queen)
        XCTAssertEqual(ChessPieceType.make(pl: "S"), .knight)
        XCTAssertEqual(ChessPieceType.make(pl: "W"), .rook)
        XCTAssertEqual(ChessPieceType.make(pl: "G"), .bishop)
    }

    func test_creatingTypeFromEnglishLetter() {
        XCTAssertEqual(ChessPieceType.make(en: "K"), .king)
        XCTAssertEqual(ChessPieceType.make(en: "Q"), .queen)
        XCTAssertEqual(ChessPieceType.make(en: "N"), .knight)
        XCTAssertEqual(ChessPieceType.make(en: "R"), .rook)
        XCTAssertEqual(ChessPieceType.make(en: "B"), .bishop)
    }
}
