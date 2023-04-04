//
//  GameState.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

typealias GamePiece = ChessPiece & MovableChessPiece

class ChessBoard {
    var pieces: [GamePiece]

    init() {
        self.pieces = []
    }

    func addPiece(_ piece: GamePiece?) {
        guard let piece = piece else {
            return
        }
        self.pieces.append(piece)
    }

    func addPieces(_ pieces: GamePiece?...) {
        for piece in pieces {
            self.addPiece(piece)
        }
    }

    func getPiece(_ square: BoardSquare) -> GamePiece? {
        self.pieces.first{ $0.square == square }
    }

    func addPieces(_ color: ChessPieceColor, _ txt: String) {
        let parts = txt.components(separatedBy: .whitespaces)
        for part in parts {
            if part.count == 2 {
                self.addPiece(Pawn(color, BoardSquare(stringLiteral: part)))
            }
        }
    }

    func isFieldFree(_ square: BoardSquare) -> Bool {
        !self.pieces.contains{ $0.square == square }
    }
}
