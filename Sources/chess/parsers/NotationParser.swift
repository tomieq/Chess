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

    @discardableResult
    public func apply(_ txt: String) throws -> [ChessMoveEvent] {
        var events: [ChessMoveEvent] = []
        let parts = txt.components(separatedBy: .whitespacesAndNewlines)
            .filter { $0.isEmpty.not }
            .filter { $0.contains(".").not }
        for part in parts {
            var type: ChessPieceType?
            var to: BoardSquare?
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
            let event = ChessMoveEvent.pieceMoved(type: type, move: ChessMove(from: piece.square, to: to))
            moveManager.consume(event)
            events.append(event)
        }
        return events
    }
}
