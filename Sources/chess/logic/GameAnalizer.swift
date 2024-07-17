//
//  GameAnalizer.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation
/*
class GameAnalizer {
    let chessBoard: ChessBoard
    let moveCalculator: MoveCalculator

    init() {
        self.chessBoard = ChessBoard()
        self.moveCalculator = MoveCalculator(chessBoard: self.chessBoard)
    }

    func ab() {
        self.chessBoard.setupGame()
//        self.chessBoard.addPieces(.white, "Ke1 a2 b2 c2 d2 e2 f2 g2 h2")
//        self.chessBoard.addPieces(.black, "Ke8 a7")
        let allMoves = self.chessBoard
            .getPieces(color: .white)
            .compactMap {
                let moves = self.moveCalculator.possibleMoves(from: $0.square)
                if let moves {
                    if !moves.passive.isEmpty {
                        print("\($0.type.plName) \($0.square) może iść na \(moves.passive)")
                    }
                    if !moves.agressive.isEmpty {
                        print("\($0.type.plName) \($0.square) może zbić na \(moves.agressive)")
                    }
                }
                return moves
            }.flatMap{ $0.passive }
        print("all white moves: \(allMoves.count)")
    }
}
*/
