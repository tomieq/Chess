//
//  King.swift
//
//
//  Created by Tomasz on 20/10/2022.
//

import Foundation



class King: DetachedChessPiece {
    convenience init?(_ color: ChessPieceColor, _ square: BoardSquare) {
        self.init(.king, color, square)
    }
/*
    var basicMoves: [BoardSquare] {
        self.square.neighbours
    }

    var copy: GamePiece? {
        King(self.color, self.square)
    }

    var canCastle: Bool {
        self.moveCounter == 0 && self.square == self.startSquare
    }

    var startSquare: BoardSquare {
        self.color == .white ? "e1" : "e8"
    }*/
}

extension King: ChessPieceConvertible {
    func chessPiece(chessBoard: ChessBoard) -> ChessPiece {
        ChessPiece(self, KingMoveCalculator(from: self.square, on: chessBoard))
    }
}
