//
//  BishopMoveTests.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation
import XCTest
@testable import chess

class BishopMoveTests: XCTestCase {
    func testMovesFromA1() throws {
        let rook = Bishop(.white, "a1")
        let basicMoves = rook?.basicMoves ?? []
        XCTAssertEqual(basicMoves.count, 7)
        XCTAssertTrue(basicMoves.contains("b2"))
        XCTAssertTrue(basicMoves.contains("c3"))
        XCTAssertTrue(basicMoves.contains("g7"))
        XCTAssertTrue(basicMoves.contains("h8"))
        XCTAssertFalse(basicMoves.contains("b1"))
    }

    func testMovesFromH3() throws {
        let rook = Bishop(.white, "h3")
        let basicMoves = rook?.basicMoves ?? []
        XCTAssertEqual(basicMoves.count, 7)
        XCTAssertTrue(basicMoves.contains("g2"))
        XCTAssertTrue(basicMoves.contains("f1"))
        XCTAssertTrue(basicMoves.contains("g4"))
        XCTAssertTrue(basicMoves.contains("c8"))
        XCTAssertFalse(basicMoves.contains("h5"))
    }

    func testMovesFromE5() throws {
        let rook = Bishop(.white, "e5")
        let basicMoves = rook?.basicMoves ?? []
        XCTAssertEqual(basicMoves.count, 13)
        XCTAssertTrue(basicMoves.contains("f6"))
        XCTAssertTrue(basicMoves.contains("f4"))
        XCTAssertTrue(basicMoves.contains("d6"))
        XCTAssertTrue(basicMoves.contains("d4"))
        XCTAssertFalse(basicMoves.contains("d5"))
    }
}
