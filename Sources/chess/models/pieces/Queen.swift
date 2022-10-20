//
//  Queen.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Queen: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ address: ChessPieceAddress) {
        self.init(.queen, color, address)
    }

    var basicMoves: [ChessPieceAddress] {
        var moves: [ChessPieceAddress?] = []
        var toUpLeft: ChessPieceAddress? = self.address
        var toUpRight: ChessPieceAddress? = self.address
        var toDownLeft: ChessPieceAddress? = self.address
        var toDownRight: ChessPieceAddress? = self.address
        var toLeft: ChessPieceAddress? = self.address
        var toRight: ChessPieceAddress? = self.address
        var toUp: ChessPieceAddress? = self.address
        var toDown: ChessPieceAddress? = self.address
        for _ in 1..<8 {
            toUpLeft = toUpLeft?.move(.up)?.move(.left)
            toUpRight = toUpRight?.move(.up)?.move(.right)
            toDownLeft = toDownLeft?.move(.down)?.move(.left)
            toDownRight = toDownRight?.move(.down)?.move(.right)
            toLeft = toLeft?.move(.left)
            toRight = toRight?.move(.right)
            toUp = toUp?.move(.up)
            toDown = toDown?.move(.down)
            moves.append(toUpLeft)
            moves.append(toUpRight)
            moves.append(toDownLeft)
            moves.append(toDownRight)
            moves.append(toLeft)
            moves.append(toRight)
            moves.append(toUp)
            moves.append(toDown)
        }
        return moves.compactMap { $0 }
    }
}
