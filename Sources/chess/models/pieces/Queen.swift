//
//  Queen.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Queen: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.queen, color, square)
    }

    var basicMoves: [BoardSquare] {
        self.square.squares(to: .upRight) + self.square.squares(to: .upLeft) + self.square.squares(to: .downRight) + self.square.squares(to: .downLeft) +
            self.square.squares(to: .right) + self.square.squares(to: .left) + self.square.squares(to: .up) + self.square.squares(to: .down)
    }

    var copy: GamePiece? {
        Queen(self.color, self.square)
    }
}
