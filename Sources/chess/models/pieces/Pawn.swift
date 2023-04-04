//
//  Pawn.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Pawn: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.pawn, color, square)
    }

    var basicMoves: [BoardSquare] {
        switch self.color {
        case .white:
            return self.basicWhiteMoves()
        case .black:
            return self.basicBlackMoves()
        }
    }

    private func basicWhiteMoves() -> [BoardSquare] {
        var moves: [BoardSquare?] = [
            self.square.move(.up),
            self.square.move(.up)?.move(.left),
            self.square.move(.up)?.move(.right)
        ]
        if self.square.row == 2 {
            moves.append(self.square.move(.up)?.move(.up))
        }
        return moves.compactMap { $0 }
    }

    private func basicBlackMoves() -> [BoardSquare] {
        var moves: [BoardSquare?] = [
            self.square.move(.down),
            self.square.move(.down)?.move(.left),
            self.square.move(.down)?.move(.right)
        ]
        if self.square.row == 7 {
            moves.append(self.square.move(.down)?.move(.down))
        }
        return moves.compactMap { $0 }
    }
}
