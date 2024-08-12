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
    case reloadBoard
    case pgn(String)
    case fen(String)
    case tip(String)
    case comment(String)
    case error(CustomStringConvertible)
    case whiteDump(String)
    case blackDump(String)
    
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
        case .reloadBoard:
            "reloadBoard:"
        case .pgn(let txt):
            "pgn:\(txt)"
        case .fen(let txt):
            "fen:\(txt)"
        case .tip(let txt):
            "tip:\(txt)"
        case .comment(let txt):
            "comment:\(txt)"
        case .error(let txt):
            "error:\(txt)"
        case .whiteDump(let txt):
            "white:\(txt)"
        case .blackDump(let txt):
            "black:\(txt)"
        }
    }
}
