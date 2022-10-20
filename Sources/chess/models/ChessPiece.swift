//
//  ChessPiece.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

protocol MovableChessPiece {
    var basicMoves: [ChessPieceAddress] { get }
}

class ChessPiece {
    let type: ChessPieceType
    let color: ChessPieceColor
    var address: ChessPieceAddress

    init?(_ type: ChessPieceType, _ color: ChessPieceColor, _ address: ChessPieceAddress?) {
        guard let position = address else {
            print("Could not initialize \(type) as adress is nil")
            return nil
        }
        self.type = type
        self.color = color
        self.address = position
    }

    convenience init?(_ type: ChessPieceType, _ color: ChessPieceColor, _ column: BoardColumn, _ row: Int) {
        self.init(type, color, ChessPieceAddress(column, row))
    }

    convenience init?(_ type: ChessPieceType, _ color: ChessPieceColor, _ textAddress: String) {
        guard let address = ChessPieceAddress(textAddress) else {
            print("Invalid text address(\(textAddress)) while creating ChessPiece")
            return nil
        }
        self.init(type, color, address)
    }
}
