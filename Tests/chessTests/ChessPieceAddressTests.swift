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
        XCTAssertNotNil(nextAddress)
        nextAddress = address?.move(.down)
        XCTAssertNil(nextAddress)
        nextAddress = address?.move(.up)
        XCTAssertNotNil(nextAddress)
    }

    func test_movesFromRightBottom() throws {
        let address = ChessPieceAddress(.h, 1)
        XCTAssertNotNil(address)
        var nextAddress = address?.move(.left)
        XCTAssertNotNil(nextAddress)
        nextAddress = address?.move(.right)
        XCTAssertNil(nextAddress)
        nextAddress = address?.move(.down)
        XCTAssertNil(nextAddress)
        nextAddress = address?.move(.up)
        XCTAssertNotNil(nextAddress)
    }

    func test_movesFromLeftTop() throws {
        let address = ChessPieceAddress(.a, 8)
        XCTAssertNotNil(address)
        var nextAddress = address?.move(.left)
        XCTAssertNil(nextAddress)
        nextAddress = address?.move(.right)
        XCTAssertNotNil(nextAddress)
        nextAddress = address?.move(.down)
        XCTAssertNotNil(nextAddress)
        nextAddress = address?.move(.up)
        XCTAssertNil(nextAddress)
    }

    func test_movesFromRightTop() throws {
        let address = ChessPieceAddress(.h, 8)
        XCTAssertNotNil(address)
        var nextAddress = address?.move(.left)
        XCTAssertNotNil(nextAddress)
        nextAddress = address?.move(.right)
        XCTAssertNil(nextAddress)
        nextAddress = address?.move(.down)
        XCTAssertNotNil(nextAddress)
        nextAddress = address?.move(.up)
        XCTAssertNil(nextAddress)
    }
}
