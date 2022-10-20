//
//  RookMoveTests.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation
@testable import chess
import XCTest

class RookMoveTests: XCTestCase {
    func testMovesFromA1() throws {
        let rook = Rook(.white, "a1")
        let basicMoves = rook?.basicMoves ?? []
        XCTAssertEqual(basicMoves.count, 14)
        XCTAssertTrue(basicMoves.contains("b1"))
        XCTAssertTrue(basicMoves.contains("h1"))
        XCTAssertTrue(basicMoves.contains("a4"))
        XCTAssertTrue(basicMoves.contains("a8"))
        XCTAssertFalse(basicMoves.contains("b2"))
    }

    func testMovesFromD4() throws {
        let rook = Rook(.white, "d4")
        let basicMoves = rook?.basicMoves ?? []
        XCTAssertEqual(basicMoves.count, 14)
        XCTAssertTrue(basicMoves.contains("d1"))
        XCTAssertTrue(basicMoves.contains("h4"))
        XCTAssertTrue(basicMoves.contains("d3"))
        XCTAssertTrue(basicMoves.contains("a4"))
        XCTAssertFalse(basicMoves.contains("c3"))
    }
}
