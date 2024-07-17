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

    var copy: ChessBoard {
        ChessBoard(pieces: self.pieces.compactMap{ $0.copy })
    }

    init() {
        self.pieces = []
    }

    private init(pieces: [GamePiece]) {
        self.pieces = pieces
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

    func getKing(color: ChessPieceColor) -> ChessPiece? {
        self.pieces.first { $0.type == .king && $0.color == color }
    }

    func isSquareFree(_ square: BoardSquare) -> Bool {
        !self.pieces.contains{ $0.square == square }
    }

    func setupGame() {
        let chessboardLoader = ChessBoardLoader(chessBoads: self)
        chessboardLoader
            .load(.white, "Wa1 Sb1 Gc1 Hd1 Ke1 Gf1 Sg1 Wh1")
            .load(.white, "a2 b2 c2 d2 e2 f2 g2 h2")
            .load(.black, "Wa8 Sb8 Gc8 Hd8 Ke8 Gf8 Sg8 Wh8")
            .load(.black, "a7 b7 c7 d7 e7 f7 g7 h7")
    }

    func getPieces(color: ChessPieceColor) -> [GamePiece] {
        self.pieces.filter{ $0.color == color }
    }

    func remove(_ square: BoardSquare) {
        self.pieces = self.pieces.filter{ $0.square != square }
    }

    func move(source: BoardSquare, to dest: BoardSquare) {
        guard let piece = self.getPiece(source) else {
            print("Cannot move piece from \(source) as there is nothing!")
            return
        }
        self.remove(source)
        self.remove(dest)
        piece.square = dest
        self.addPiece(piece)
    }

    var dump: String {
        var txt = ""
        for color in ChessPieceColor.allCases {
            let pieces = self.getPieces(color: color)
            let log = pieces.map{ ($0.type.plLetter + $0.square.description) }.joined(separator: " ")
            txt.append("\(color): \(log)\n")
        }
        return txt.trimmingCharacters(in: .newlines)
    }
}
