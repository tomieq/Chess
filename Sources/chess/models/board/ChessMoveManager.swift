//
//  ChessMoveManager.swift
//  chess
//
//  Created by Tomasz Kucharski on 05/08/2024.
//

public enum ChessMoveError: Error {
    case invalidSquare
    case noPiece(at: BoardSquare)
    case colorOnMove(ChessPieceColor)
    case canNotMove(type: ChessPieceType, to: BoardSquare)
}

public class ChessMoveManager {
    let chessboard: ChessBoard
    public var colorOnMove: ChessPieceColor = .white
    public var eventHandler: ((ChessMoveEvent) -> Void)?
    
    public init(chessboard: ChessBoard) {
        self.chessboard = chessboard
    }
    
    public func move(from: BoardSquare?, to: BoardSquare?) throws {
        guard let from = from, let to = to else {
            print("Invalid square")
            throw ChessMoveError.invalidSquare
        }
        let move = ChessMove(from: from, to: to)
        guard let piece = chessboard[from] else {
            print("No piece at \(from)")
            throw ChessMoveError.noPiece(at: from)
        }
        guard piece.color == colorOnMove else {
            print("Cannot move with \(piece) as now only \(colorOnMove) can move now")
            throw ChessMoveError.colorOnMove(colorOnMove)
        }
        guard piece.moveCalculator.possibleMoves.contains(to) else {
            print("\(piece) cannot move to \(to). It can move only to \(piece.moveCalculator.possibleMoves)")
            throw ChessMoveError.canNotMove(type: piece.type, to: to)
        }
        if let event = promotionMove(piece: piece, move: move) {
            consume(event)
            return
        }
        if let event = castlingMove(piece: piece, move: move) {
            consume(event)
            return
        }
        if let attackedPiece = chessboard[to] {
            consume(.pieceTakes(type: piece.type, move: move, takenType: attackedPiece.type, status: chessboard.status(for: piece.color)))
            print("\(piece.color) \(piece.type.enName) from \(from) took \(attackedPiece)")
        } else {
            consume(.pieceMoved(type: piece.type, move: move, status: chessboard.status(for: piece.color)))
            print("\(piece.color) \(piece.type.enName) moved from \(from) to \(to)")
        }
    }
    
    private func castlingMove(piece: ChessPiece, move: ChessMove) -> ChessMoveEvent? {
        if piece.type == .king, piece.moveCalculator.moveCounter == 0 {
            switch piece.color {
            case .white:
                if move.to == "g1" {
                    return .castling(side: Castling.kingSide(.white), status: chessboard.status(for: piece.color))
                }
                if move.to == "c1" {
                    return .castling(side: Castling.queenSide(.white), status: chessboard.status(for: piece.color))
                }
            case .black:
                if move.to == "g8" {
                    return .castling(side: Castling.kingSide(.black), status: chessboard.status(for: piece.color))
                }
                if move.to == "c8" {
                    return .castling(side: Castling.queenSide(.black), status: chessboard.status(for: piece.color))
                }
            }
            
        }
        return nil
    }
    
    private func promotionMove(piece: ChessPiece, move: ChessMove) -> ChessMoveEvent? {
        if piece.type == .pawn {
            switch piece.color {
            case .white:
                if move.to.row == 8 {
                    return .promotion(move: move, type: .queen, status: chessboard.status(for: piece.color))
                }
            case .black:
                if move.to.row == 1 {
                    return .promotion(move: move, type: .queen, status: chessboard.status(for: piece.color))
                }
            }
        }
        return nil
    }
    
    func consume(_ event: ChessMoveEvent) {
        defer {
            colorOnMove = colorOnMove.other
        }
        switch event {
        case .pieceMoved(_, let move, _):
            chessboard.move(move)
        case .pieceTakes(_, let move, _, _):
            chessboard.move(move)
        case .promotion(let move, _, _):
            chessboard.remove(move.to, move.from)
            chessboard.add(Queen(colorOnMove, move.to))
        case .castling(let castling, _):
            castling.moves.forEach { chessboard.move($0) }
        }
        eventHandler?(event)
    }
}
