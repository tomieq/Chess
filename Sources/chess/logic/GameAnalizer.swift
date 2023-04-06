//
//  GameAnalizer.swift
//
//
//  Created by Tomasz on 05/04/2023.
//

import Foundation

class GameAnalizer {
    let chessBoard: ChessBoard
    let moveCalculator: MoveCalculator

    init() {
        self.chessBoard = ChessBoard()
        self.moveCalculator = MoveCalculator(chessBoard: self.chessBoard)
    }

    func ab() {
        self.chessBoard.setupGame()
        let allMoves = self.chessBoard
            .getPieces(color: .white)
            .compactMap{
                let moves = self.moveCalculator.possibleMoves(from: $0.square)
                if let moves {
                    print("\($0.type.plName) \($0.square) może iść na \(moves)")
                }
                return moves
            }.flatMap{ $0.passive }
        print("all white moves: \(allMoves.count)")
    }
}
