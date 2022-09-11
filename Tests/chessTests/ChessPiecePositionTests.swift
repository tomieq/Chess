//
//  ChessPiecePositionTests.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import XCTest
@testable import chess

final class ChessPiecePositionTests: XCTestCase {
    func test_movesFromLeftBottom() throws {
        let position = ChessPiecePosition(.a, 1)
        XCTAssertNotNil(position)
        var nextChessPiecePosition = position?.move(.left)
        XCTAssertNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.right)
        XCTAssertNotNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.down)
        XCTAssertNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.up)
        XCTAssertNotNil(nextChessPiecePosition)
    }

    func test_movesFromRightBottom() throws {
        let position = ChessPiecePosition(.h, 1)
        XCTAssertNotNil(position)
        var nextChessPiecePosition = position?.move(.left)
        XCTAssertNotNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.right)
        XCTAssertNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.down)
        XCTAssertNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.up)
        XCTAssertNotNil(nextChessPiecePosition)
    }

    func test_movesFromLeftTop() throws {
        let position = ChessPiecePosition(.a, 8)
        XCTAssertNotNil(position)
        var nextChessPiecePosition = position?.move(.left)
        XCTAssertNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.right)
        XCTAssertNotNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.down)
        XCTAssertNotNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.up)
        XCTAssertNil(nextChessPiecePosition)
    }

    func test_movesFromRightTop() throws {
        let position = ChessPiecePosition(.h, 8)
        XCTAssertNotNil(position)
        var nextChessPiecePosition = position?.move(.left)
        XCTAssertNotNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.right)
        XCTAssertNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.down)
        XCTAssertNotNil(nextChessPiecePosition)
        nextChessPiecePosition = position?.move(.up)
        XCTAssertNil(nextChessPiecePosition)
    }
}
