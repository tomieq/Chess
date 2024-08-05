//
//  ChessBoardLoader.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

class ChessBoardLoader {
    let chessBoads: ChessBoard
    
    init(chessBoads: ChessBoard) {
        self.chessBoads = chessBoads
    }
    
    // adds pieces to the board parsing the text, e.g.:
    // Ke1 Ra1 Rh1 c2
    @discardableResult
    func load(_ color: ChessPieceColor, _ txt: String, language: Language = .english) -> ChessBoardLoader {
        let parts = txt.components(separatedBy: .whitespaces)
        for part in parts {
            if part.count == 2 {
                chessBoads.addPiece(Pawn(color, BoardSquare(stringLiteral: part)))
                continue
            }
            let square = BoardSquare(stringLiteral: part.subString(1, 3))
            guard let type = ChessPieceType.make(letter: part.subString(0, 1), language: language) else {
                continue
            }
            switch type {
            case .king:
                chessBoads.addPiece(King(color, square))
            case .queen:
                chessBoads.addPiece(Queen(color, square))
            case .rook:
                chessBoads.addPiece(Rook(color, square))
            case .bishop:
                chessBoads.addPiece(Bishop(color, square))
            case .knight:
                chessBoads.addPiece(Knight(color, square))
            case .pawn:
                chessBoads.addPiece(Pawn(color, square))
            }
        }
        return self
    }
}
