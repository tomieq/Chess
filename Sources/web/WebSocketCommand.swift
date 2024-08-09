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
    case text(String)
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
        case .text(let txt):
            "text:\(txt)"
        case .whiteDump(let txt):
            "white:\(txt)"
        case .blackDump(let txt):
            "black:\(txt)"
        }
    }
}
