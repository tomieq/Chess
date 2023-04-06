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

    func addPieces(_ color: ChessPieceColor, _ txt: String, language: Language = .polish) {
        let parts = txt.components(separatedBy: .whitespaces)
        for part in parts {
            if part.count == 2 {
                self.addPiece(Pawn(color, BoardSquare(stringLiteral: part)))
                continue
            }
            let square = BoardSquare(stringLiteral: part.subString(1, 3))
            guard let type = ChessPieceType.make(letter: part.subString(0, 1), language: language) else {
                continue
            }
            switch type {
            case .king:
                self.addPiece(King(color, square))
            case .queen:
                self.addPiece(Queen(color, square))
            case .rook:
                self.addPiece(Rook(color, square))
            case .bishop:
                self.addPiece(Bishop(color, square))
            case .knight:
                self.addPiece(Knight(color, square))
            case .pawn:
                self.addPiece(Pawn(color, square))
            }
        }
    }

    func isSquareFree(_ square: BoardSquare) -> Bool {
        !self.pieces.contains{ $0.square == square }
    }

    func setupGame() {
        self.addPieces(.white, "Wa1 Sb1 Gc1 Hd1 Ke1 Gf1 Sg1 Wh1")
        self.addPieces(.white, "a2 b2 c2 d2 e2 f2 g2 h2")
        self.addPieces(.black, "Wa8 Sb8 Gc8 Hd8 Ke8 Gf8 Sg8 Wh8")
        self.addPieces(.black, "a7 b7 c7 d7 e7 f7 g7 h7")
    }

    func getPieces(color: ChessPieceColor) -> [GamePiece] {
        self.pieces.filter{ $0.color == color }
    }

    func remove(_ square: BoardSquare) {
        self.pieces = self.pieces.filter{ $0.square != square }
    }
}
