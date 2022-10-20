//
//  Knight.swift
//  
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class Knight: ChessPiece, MovableChessPiece {
    convenience init?(_ color: ChessPieceColor, _ address: String) {
        self.init(.knight, color, address)
    }

    var basicMoves: [ChessPieceAddress] {
        [
            self.address.move(.right)?.move(.right)?.move(.up),
            self.address.move(.right)?.move(.right)?.move(.down),
            self.address.move(.left)?.move(.left)?.move(.up),
            self.address.move(.left)?.move(.left)?.move(.down),
            self.address.move(.up)?.move(.up)?.move(.right),
            self.address.move(.up)?.move(.up)?.move(.left),
            self.address.move(.down)?.move(.down)?.move(.right),
            self.address.move(.down)?.move(.down)?.move(.left),
        ].compactMap { $0 }
    }
}
