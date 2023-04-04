//
//  King.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class King: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ address: ChessPieceAddress) {
        self.init(.king, color, address)
    }

    var basicMoves: [ChessPieceAddress] {
        self.address.neighbours
    }

    var canCastle: Bool {
        self.moveCounter == 0 && self.address == self.startAddress
    }

    var startAddress: ChessPieceAddress {
        self.color == .white ? "e1" : "e8"
    }
}
