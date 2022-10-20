//
//  King.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation

class King: ChessPiece, MovableChessPiece {
    
    convenience init?(_ color: ChessPieceColor, _ address: String) {
        self.init(.king, color, address)
    }
    
    var basicMoves: [ChessPieceAddress] {
        [self.address.move(.right),
         self.address.move(.left),
         self.address.move(.up),
         self.address.move(.down),
         self.address.move(.up)?.move(.left),
         self.address.move(.up)?.move(.right),
         self.address.move(.down)?.move(.left),
         self.address.move(.down)?.move(.right)].compactMap { $0 }
    }
}
