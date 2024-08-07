//
//  ChessMove.swift
//  chess
//
//  Created by Tomasz Kucharski on 07/08/2024.
//

public struct ChessMove {
    public enum Change {
        case move(ChessBoardMove)
        case remove(ChessPieceType, from: BoardSquare)
        case add(ChessPieceType, to: BoardSquare)
    }
    public let color: ChessPieceColor
    public let notation: String
    public let changes: [Change]
    public let status: ChessGameStatus
}
