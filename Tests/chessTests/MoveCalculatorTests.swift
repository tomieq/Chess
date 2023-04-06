//
//  MoveCalculatorTests.swift
//
//
//  Created by Tomasz on 06/04/2023.
//

@testable import chess
import XCTest

class MoveCalculatorTests: XCTestCase {
    func test_backupFromRook() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "f4 Wb4 We1")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let backup = sut.backup(for: "f4")
        XCTAssertEqual(backup.count, 1)
        XCTAssertEqual(backup[0].square, "b4")
    }

    func test_backupFromBishop() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "f4 Wb4 We1 Gd2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let backup = sut.backup(for: "f4").map{ $0.square }
        XCTAssertEqual(backup.count, 2)
        XCTAssertEqual(backup.contains("b4"), true)
        XCTAssertEqual(backup.contains("d2"), true)
    }
}
