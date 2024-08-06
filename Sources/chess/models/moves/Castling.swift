//
//  Castling.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//

public enum Castling {
    case kingSide(ChessPieceColor)
    case queenSide(ChessPieceColor)
    
    public var moves: [ChessMove] {
        switch self {
        case .kingSide(let color):
            switch color {
            case .white:
                [ChessMove(from: "e1", to: "g1"), ChessMove(from: "h1", to: "f1")]
            case .black:
                [ChessMove(from: "e8", to: "g8"), ChessMove(from: "h8", to: "f8")]
            }
        case .queenSide(let color):
            switch color {
            case .white:
                [ChessMove(from: "e1", to: "c1"), ChessMove(from: "a1", to: "d1")]
            case .black:
                [ChessMove(from: "e8", to: "c8"), ChessMove(from: "a8", to: "d8")]
            }
        }
    }
}
extension Castling: Equatable {}
