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
        self.square.squares(to: .upRight) + self.square.squares(to: .upLeft) + self.square.squares(to: .downRight) + self.square.squares(to: .downLeft)
    }

    var copy: GamePiece? {
        Bishop(self.color, self.square)
    }
}
