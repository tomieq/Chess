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
        let address = ChessPieceAddress(.a, 1)
        XCTAssertNotNil(address)
        var nextAddress = address?.move(.left)
        XCTAssertNil(nextAddress)
        nextAddress = address?.move(.right)
        XCTAssertEqual(nextAddress, "b1")
        nextAddress = address?.move(.down)
        XCTAssertNil(nextAddress)
        nextAddress = address?.move(.up)
        XCTAssertEqual(nextAddress, "a2")
    }

    func test_movesFromRightBottom() throws {
        let address = ChessPieceAddress(.h, 1)
        XCTAssertNotNil(address)
        var nextAddress = address?.move(.left)
        XCTAssertEqual(nextAddress, "g1")
        nextAddress = address?.move(.right)
        XCTAssertNil(nextAddress)
        nextAddress = address?.move(.down)
        XCTAssertNil(nextAddress)
        nextAddress = address?.move(.up)
        XCTAssertEqual(nextAddress, "h2")
    }

    func test_movesFromLeftTop() throws {
        let address = ChessPieceAddress(.a, 8)
        XCTAssertNotNil(address)
        var nextAddress = address?.move(.left)
        XCTAssertNil(nextAddress)
        nextAddress = address?.move(.right)
        XCTAssertEqual(nextAddress, "b8")
        nextAddress = address?.move(.down)
        XCTAssertEqual(nextAddress, "a7")
        nextAddress = address?.move(.up)
        XCTAssertNil(nextAddress)
    }

    func test_movesFromRightTop() throws {
        let address = ChessPieceAddress(.h, 8)
        XCTAssertNotNil(address)
        var nextAddress = address?.move(.left)
        XCTAssertEqual(nextAddress, "g8")
        nextAddress = address?.move(.right)
        XCTAssertNil(nextAddress)
        nextAddress = address?.move(.down)
        XCTAssertEqual(nextAddress, "h7")
        nextAddress = address?.move(.up)
        XCTAssertNil(nextAddress)
    }

    func test_isDiagonal() throws {
        XCTAssertTrue(ChessPieceAddress("d3").isDiagonal(to: "c2"))
        XCTAssertTrue(ChessPieceAddress("d3").isDiagonal(to: "b1"))
        XCTAssertTrue(ChessPieceAddress("d3").isDiagonal(to: "f5"))
        XCTAssertTrue(ChessPieceAddress("d3").isDiagonal(to: "b5"))
        XCTAssertTrue(ChessPieceAddress("g1").isDiagonal(to: "a7"))
        XCTAssertFalse(ChessPieceAddress("e1").isDiagonal(to: "a6"))
    }

    func test_horizontalRangeToRight() {
        let start = ChessPieceAddress("d3")
        XCTAssertEqual(start.path(to: "h3").count, 5)
        XCTAssertEqual(start.path(to: "d3").count, 1)
        XCTAssertEqual(start.path(to: "g3").count, 4)
        XCTAssertEqual(start.path(to: "f3").count, 3)
    }

    func test_horizontalRangeToLeft() {
        let start = ChessPieceAddress("f6")
        XCTAssertEqual(start.path(to: "a6").count, 6)
        XCTAssertEqual(start.path(to: "f6").count, 1)
        XCTAssertEqual(start.path(to: "c6").count, 4)
        XCTAssertEqual(start.path(to: "d6").count, 3)
    }

    func test_verticalRangeToUp() {
        let start = ChessPieceAddress("d2")
        XCTAssertEqual(start.path(to: "d8").count, 7)
        XCTAssertEqual(start.path(to: "d3").count, 2)
        XCTAssertEqual(start.path(to: "d5").count, 4)
    }

    func test_verticalRangeToDown() {
        let start = ChessPieceAddress("f6")
        XCTAssertEqual(start.path(to: "f1").count, 6)
        XCTAssertEqual(start.path(to: "f4").count, 3)
        XCTAssertEqual(start.path(to: "f5").count, 2)
    }

    func test_diagonalTopRight() {
        let start = ChessPieceAddress("e3")
        XCTAssertEqual(start.path(to: "f4").count, 2)
        XCTAssertEqual(start.path(to: "g5").count, 3)
        XCTAssertTrue(start.path(to: "g5").contains("f4"))
        XCTAssertEqual(start.path(to: "h6").count, 4)
    }

    func test_diagonalTopLeft() {
        let start = ChessPieceAddress("e3")
        XCTAssertEqual(start.path(to: "d4").count, 2)
        XCTAssertEqual(start.path(to: "c5").count, 3)
        XCTAssertTrue(start.path(to: "c5").contains("d4"))
        XCTAssertEqual(start.path(to: "b6").count, 4)
    }

    func test_diagonalBottomLeft() {
        let start = ChessPieceAddress("f4")
        XCTAssertEqual(start.path(to: "e3").count, 2)
        XCTAssertEqual(start.path(to: "d2").count, 3)
        XCTAssertTrue(start.path(to: "d2").contains("e3"))
        XCTAssertEqual(start.path(to: "c1").count, 4)
    }

    func test_diagonalBottomRight() {
        let start = ChessPieceAddress("c4")
        XCTAssertEqual(start.path(to: "d3").count, 2)
        XCTAssertEqual(start.path(to: "e2").count, 3)
        XCTAssertTrue(start.path(to: "e2").contains("d3"))
        XCTAssertEqual(start.path(to: "f1").count, 4)
    }
}
