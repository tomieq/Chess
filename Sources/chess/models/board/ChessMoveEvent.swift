//
//  ChessMoveEvent.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//

public enum ChessMoveEvent {
    case pieceMoved(type: ChessPieceType, move: ChessMove, status: ChessGameStatus)
    case pieceTakes(type: ChessPieceType, move: ChessMove, takenType: ChessPieceType, status: ChessGameStatus)
    case promotion(move: ChessMove, type: ChessPieceType, status: ChessGameStatus)
    case castling(side: Castling, status: ChessGameStatus)
}
extension ChessMoveEvent: Equatable {}

extension ChessMoveEvent {
    func with(status new: ChessGameStatus) -> ChessMoveEvent {
        switch self {
        case .pieceMoved(let type, let move, _):
            return .pieceMoved(type: type, move: move, status: new)
        case .pieceTakes(let type, let move, let takenType, _):
            return .pieceTakes(type: type, move: move, takenType: takenType, status: new)
        case .promotion(let move, let type, _):
            return .promotion(move: move, type: type, status: new)
        case .castling(let side, _):
            return .castling(side: side, status: new)
        }
    }
}

extension ChessMoveEvent {
    public var notation: String {
        switch self {
        case .pieceMoved(let type, let move, let status):
            return "\(type.enLetter)\(move.to)\(status.notation)"
        case .pieceTakes(let type, let move, _, let status):
            var letter = type.enLetter
            if letter.isEmpty { letter = "\(move.from.column.letter)" }
            return "\(letter)x\(move.to)\(status.notation)"
        case .promotion(let move, let type, let status):
            return "\(move.to)=\(type.enLetter)\(status.notation)"
        case .castling(let side, let status):
            return "\(side.notation)\(status.notation)"
        }
    }
}
