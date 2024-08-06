//
//  WebSocketCommand.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//
import chess

enum WebSocketCommand {
    case removePiece(BoardSquare)
    case addPiece(BoardSquare, letter: String)
    case checkMate
    case hideNextMoveButton
    case text(String)
    
    var raw: String {
        switch self {
        case .removePiece(let square):
            "remove:\(square)"
        case .addPiece(let square, let letter):
            "add:\(letter):\(square)"
        case .checkMate:
            "checkmate:"
        case .hideNextMoveButton:
            "noMoreMoves:"
        case .text(let txt):
            "text:\(txt)"
        }
    }
}
