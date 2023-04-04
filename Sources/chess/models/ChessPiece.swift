//
//  ChessPiece.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

protocol MovableChessPiece {
    var basicMoves: [BoardSquare] { get }
}

class ChessPiece {
    let type: ChessPieceType
    let color: ChessPieceColor
    var square: BoardSquare {
        didSet {
            self.moveCounter += 1
        }
    }

    var moveCounter = 0

    init?(_ type: ChessPieceType, _ color: ChessPieceColor, _ square: BoardSquare?) {
        guard let position = square else {
            print("Could not initialize \(type) as square is nil")
            return nil
        }
        self.type = type
        self.color = color
        self.square = position
    }

    convenience init?(_ type: ChessPieceType, _ color: ChessPieceColor, _ column: BoardColumn, _ row: Int) {
        self.init(type, color, BoardSquare(column, row))
    }
}
