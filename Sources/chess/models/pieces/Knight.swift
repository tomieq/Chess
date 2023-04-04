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
            self.square.move(.right)?.move(.right)?.move(.up),
            self.square.move(.right)?.move(.right)?.move(.down),
            self.square.move(.left)?.move(.left)?.move(.up),
            self.square.move(.left)?.move(.left)?.move(.down),
            self.square.move(.up)?.move(.up)?.move(.right),
            self.square.move(.up)?.move(.up)?.move(.left),
            self.square.move(.down)?.move(.down)?.move(.right),
            self.square.move(.down)?.move(.down)?.move(.left)
        ].compactMap { $0 }
    }
}
