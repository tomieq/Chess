//
//  QueenMoveTests.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import XCTest
@testable import chess

final class QueenMoveTests: XCTestCase {
    
    let chessBoard = ChessBoard()
    
    private func possibleMoves(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possibleMoves ?? []
    }
    
    private func supports(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.backedUpFriends ?? []
    }
    
    private func attacks(from square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possibleVictims ?? []
    }
    
    private func attackedBy(on square: BoardSquare?) -> [BoardSquare] {
        chessBoard.piece(at: square)?.moveCalculator.possiblePredators ?? []
    }
    
    func test_initialMoves() throws {
        let chessboardLoader = ChessBoardLoader(chessBoads: chessBoard)
        chessboardLoader.load(.white, "He4")
        XCTAssertEqual(possibleMoves(from: "e4").count, 27)
        XCTAssertEqual(attacks(from: "e4").count, 0)

        chessboardLoader.load(.black, "We6")
        XCTAssertEqual(possibleMoves(from: "e4").count, 25)
        XCTAssertEqual(attacks(from: "e4").count, 1)
        XCTAssertEqual(attackedBy(on: "e4").count, 1)

        chessboardLoader.load(.black, "Ke1")
        XCTAssertEqual(possibleMoves(from: "e4").count, 25)
        XCTAssertEqual(attacks(from: "e4").count, 2)

        chessboardLoader.load(.white, "c2")
        XCTAssertEqual(possibleMoves(from: "e4").count, 23)
        XCTAssertEqual(attacks(from: "e4").count, 2)
    }

    func test_diagonalKingDefence() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1 Hd2")
            .load(.black, "Ke8 Ha5")
        let moves = possibleMoves(from: "d2")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("c3"), true)
        XCTAssertEqual(moves.contains("b4"), true)
        XCTAssertEqual(attacks(from: "d2"), ["a5"])
    }
}

