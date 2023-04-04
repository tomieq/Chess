//
//  ChessBoardTests.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation
@testable import chess
import XCTest

class ChessBoardTests: XCTestCase {
    func test_addingPieceToGame() {
        let sut = ChessBoard()
        sut.addPiece(Knight(.black, "c6"))

        let piece = sut.getPiece("c6")
        XCTAssertEqual(piece?.type, .knight)
        XCTAssertEqual(piece?.color, .black)
    }

    func test_addingPawnFromText() {
        let sut = ChessBoard()
        sut.addPieces(.black, "c7 d7 f7")
        sut.addPieces(.white, "b2")
        XCTAssertEqual(sut.pieces.count, 4)
        XCTAssertEqual(sut.getPiece("c7")?.type, .pawn)
        XCTAssertEqual(sut.getPiece("d7")?.type, .pawn)
        XCTAssertEqual(sut.getPiece("f7")?.type, .pawn)
        XCTAssertEqual(sut.getPiece("f7")?.color, .black)
        XCTAssertEqual(sut.getPiece("b2")?.type, .pawn)
        XCTAssertEqual(sut.getPiece("b2")?.color, .white)
    }
}