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
}
