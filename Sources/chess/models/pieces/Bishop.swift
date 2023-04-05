//
//  Bishop.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Bishop: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.bishop, color, square)
    }

    var basicMoves: [BoardSquare] {
        self.squares(to: .upRight) + self.squares(to: .upLeft) + self.squares(to: .downRight) + self.squares(to: .downLeft)
    }

    func squares(to direction: DiagonalDirection) -> [BoardSquare] {
        var moves: [BoardSquare?] = []
        var square: BoardSquare? = self.square
        for _ in 1..<8 {
            square = square?.move(direction)
            if square.isNil {
                break
            }
            moves.append(square)
        }
        return moves.compactMap { $0 }
    }
}
