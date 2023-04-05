//
//  Rook.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Rook: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.rook, color, square)
    }

    var basicMoves: [BoardSquare] {
        self.moves(to: .right) + self.moves(to: .left) + self.moves(to: .up) + self.moves(to: .down)
    }

    var canCastle: Bool {
        self.moveCounter == 0 && self.isAtStartingPosition
    }

    var isAtStartingPosition: Bool {
        switch self.color {
        case .white:
            return ["a1", "h1"].contains(self.square)
        case .black:
            return ["a8", "h8"].contains(self.square)
        }
    }

    func moves(to direction: MoveDirection) -> [BoardSquare] {
        var moves: [BoardSquare?] = []
        var square: BoardSquare? = self.square
        for _ in 1..<8 {
            square = square?.move(direction)
            moves.append(square)
        }
        return moves.compactMap { $0 }
    }
}
