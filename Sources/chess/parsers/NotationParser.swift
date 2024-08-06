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
            // https://en.wikipedia.org/wiki/Numeric_Annotation_Glyphs#main
            .filter { $0.contains("$").not }
            .map { $0.replacingOccurrences(of: "?", with: "").replacingOccurrences(of: "!", with: "") }
    }

    @discardableResult
    public func apply(_ txt: String) throws -> [ChessMoveEvent] {
        print("parsing \(txt)")
        var events: [ChessMoveEvent] = []
        let parts = split(txt)
        for part in parts {
            if isFinished(part) { break }
            let event = try parseCastling(part) ?? parseSingleMove(part)
            moveManager.consume(event)
            events.append(event)
        }
        return events
    }
    
    private func isFinished(_ part: String) -> Bool {
        if ["1-0", "0-1", "½-½", "0.5-0.5", "*", "+/-", "-/-", "-/+"].contains(part) {
            return true
        }
        return false
    }
    
    private func parseCastling(_ part: String) -> ChessMoveEvent? {
        let color = moveManager.colorOnMove
        let status: ChessGameStatus = part.contains("+") ? .check : part.contains("#") ? .checkmate : .normal
        let part = part.replacingOccurrences(of: "+", with: "").replacingOccurrences(of: "#", with: "")
        if part == "O-O" || part == "0-0"{
            return .castling(side: Castling.kingSide(color), status: status)
        } else if part == "O-O-O" || part == "0-0-0"{
            return .castling(side: Castling.queenSide(color), status: status)
        }
        return nil
    }

    private func parseSingleMove(_ part: String) throws -> ChessMoveEvent {
        var type: ChessPieceType?
        var to: BoardSquare?
        let takes = part.contains("x")
        let status: ChessGameStatus = part.contains("+") ? .check : part.contains("#") ? .checkmate : .normal
        let part = part.replacingOccurrences(of: "x", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "#", with: "")
        var column: BoardColumn?
        if part.count == 2 {
            type = .pawn
            to = BoardSquare(stringLiteral: part)
        } else if part.count == 4 {
            to = BoardSquare(stringLiteral: part.subString(2, 4))
            type = ChessPieceType.make(letter: part.subString(0, 1), language: language) ?? .pawn
            column = BoardColumn(part.subString(1, 2))
        } else {
            to = BoardSquare(stringLiteral: part.subString(1, 3))
            type = ChessPieceType.make(letter: part.subString(0, 1), language: language) ?? .pawn
        }
        guard let type = type, let to = to else {
            throw NotationParserError.parsingError("Invalid entry \(part)")
        }
        var pieces = moveManager.chessboard
            .getPieces(color: moveManager.colorOnMove)
            .filter { $0.type == type }
            .filter { $0.moveCalculator.possibleMoves.contains(to)}
        if let column = column {
            pieces = pieces.filter { $0.square.column == column }
        }
        guard pieces.count == 1, let piece = pieces.first else {
            throw NotationParserError.parsingError("Ambigious entry \(part)")
        }
        let move = ChessMove(from: piece.square, to: to)
        return takes ?  ChessMoveEvent.pieceTakes(type: type, move: move, takenType: moveManager.chessboard[to]?.type ?? .pawn, status: status) : ChessMoveEvent.pieceMoved(type: type, move: move, status: status)
    }
}
