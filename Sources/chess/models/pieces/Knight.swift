//
//  Knight.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Knight: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.knight, color, square)
    }

    var basicMoves: [BoardSquare] {
        [
            self.square.move(.right)?.move(.upRight),
            self.square.move(.right)?.move(.downRight),
            self.square.move(.left)?.move(.upLeft),
            self.square.move(.left)?.move(.downLeft),
            self.square.move(.up)?.move(.upRight),
            self.square.move(.up)?.move(.upLeft),
            self.square.move(.down)?.move(.downRight),
            self.square.move(.down)?.move(.downLeft)
        ].compactMap { $0 }
    }
}
