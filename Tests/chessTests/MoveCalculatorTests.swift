//
//  MoveCalculatorTests.swift
//
//
//  Created by Tomasz on 06/04/2023.
//

@testable import chess
import XCTest
/*
class MoveCalculatorTests: XCTestCase {
    func test_backupFromRook() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "f4 Wb4 We1")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let backup = sut.backup(for: "f4")
        XCTAssertEqual(backup.count, 1)
        XCTAssertEqual(backup[0].square, "b4")
    }

    func test_backupFromBishop() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "f4 Wb4 We1 Gd2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let backup = sut.backup(for: "f4").map{ $0.square }
        XCTAssertEqual(backup.count, 2)
        XCTAssertEqual(backup.contains("b4"), true)
        XCTAssertEqual(backup.contains("d2"), true)
    }

    func test_infiniteLoop() {
        let chessBoard = ChessBoard()
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "a2 b2 c2 d4 f2 g2 h2 Wa1 Hd1 Ke1 Gd2 Gd3 Sf3 Wh1")
            .load(.black, "a7 b7 c6 e6 f7 g7 h7 Wa8 Sb8 Gc8 Hd5 Ke8 Gf8 Wh8 Sf6")
        let sut = MoveCalculator(chessBoard: chessBoard)
        for color in ChessPieceColor.allCases {
            let pieces = sut.chessBoard.getPieces(color: color)
            for piece in pieces {
                if let possibleMoves = sut.possibleMoves(from: piece.square) {
                    for agressive in possibleMoves.agressive {
                        guard let inDanger = sut.chessBoard.getPiece(agressive) else { continue }
                        var info = "  🧠 \(piece.color.plName) \(piece.type.plName) z \(piece.square) może zbić \(inDanger.type.plName) na \(agressive)"
                        let backup = sut.backup(for: agressive)
                        if !backup.isEmpty {
                            info.append(", ale ma on wsparcie od \(backup.map{ "\($0.type.plName) z \($0.square)" }.joined(separator: " oraz "))")
                        }
                        print(info)
                    }
                }
            }
        }
    }
}
*/
