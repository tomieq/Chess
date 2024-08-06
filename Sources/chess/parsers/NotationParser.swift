//
//  NotationParser.swift
//  chess
//
//  Created by Tomasz Kucharski on 06/08/2024.
//
import Foundation

enum NotationParserError: Error {
    case parsingError(String)
}

public class NotationParser {
    let moveManager: ChessMoveManager
    private let language: Language

    public init(moveManager: ChessMoveManager, language: Language = .english) {
        self.moveManager = moveManager
        self.language = language
    }
    
    public func split(_ txt: String) -> [String] {
        txt.components(separatedBy: .whitespacesAndNewlines)
            .filter { $0.isEmpty.not }
            .filter { $0.contains(".").not }
            .map { $0.replacingOccurrences(of: "?", with: "") }
    }

    @discardableResult
    public func apply(_ txt: String) throws -> [ChessMoveEvent] {
        var events: [ChessMoveEvent] = []
        let parts = split(txt)
        for part in parts {
            var type: ChessPieceType?
            var to: BoardSquare?
            let takes = part.contains("x")
            let part = part.replacingOccurrences(of: "x", with: "")
            if part.count == 2 {
                type = .pawn
                to = BoardSquare(stringLiteral: part)
            } else {
                to = BoardSquare(stringLiteral: part.subString(1, 3))
                type = ChessPieceType.make(letter: part.subString(0, 1), language: language)
            }
            guard let type = type, let to = to else {
                throw NotationParserError.parsingError("Invalid entry \(part)")
            }
            let pieces = moveManager.chessboard
                .getPieces(color: moveManager.colorOnMove)
                .filter { $0.type == type }
                .filter { $0.moveCalculator.possibleMoves.contains(to)}
            guard pieces.count == 1, let piece = pieces.first else {
                throw NotationParserError.parsingError("Ambigious entry \(part)")
            }
            let move = ChessMove(from: piece.square, to: to)
            let event = takes ?  ChessMoveEvent.pieceTakes(type: type, move: move, takenType: moveManager.chessboard[to]?.type ?? .pawn) : ChessMoveEvent.pieceMoved(type: type, move: move)
            moveManager.consume(event)
            events.append(event)
            if moveManager.chessboard.isCheckMate(for: piece.color) {
                events.append(.checkMate(piece.color))
                moveManager.consume(.checkMate(piece.color))
            }
        }
        return events
    }
}
