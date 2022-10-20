//
//  Bishop.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Bishop: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ address: ChessPieceAddress) {
        self.init(.bishop, color, address)
    }

    var basicMoves: [ChessPieceAddress] {
        var moves: [ChessPieceAddress?] = []
        var toUpLeft: ChessPieceAddress? = self.address
        var toUpRight: ChessPieceAddress? = self.address
        var toDownLeft: ChessPieceAddress? = self.address
        var toDownRight: ChessPieceAddress? = self.address
        for _ in 1..<8 {
            toUpLeft = toUpLeft?.move(.up)?.move(.left)
            toUpRight = toUpRight?.move(.up)?.move(.right)
            toDownLeft = toDownLeft?.move(.down)?.move(.left)
            toDownRight = toDownRight?.move(.down)?.move(.right)
            moves.append(toUpLeft)
            moves.append(toUpRight)
            moves.append(toDownLeft)
            moves.append(toDownRight)
        }
        return moves.compactMap { $0 }
    }
}
