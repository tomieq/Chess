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



public enum ChessMoveEvent {
    case pieceMoved(type: ChessPieceType, move: ChessMove)
    case pieceTakes(type: ChessPieceType, move: ChessMove, takenType: ChessPieceType)
    case promotion(move: ChessMove, type: ChessPieceType)
    case castling(side: Castling)
    case checkMate(ChessPieceColor)
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
        defer {
            colorOnMove = colorOnMove.other
            checkForGameOver()
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
            consume(.pieceTakes(type: piece.type, move: move, takenType: attackedPiece.type))
            print("\(piece.color) \(piece.type.enName) from \(from) took \(attackedPiece)")
        } else {
            consume(.pieceMoved(type: piece.type, move: move))
            print("\(piece.color) \(piece.type.enName) moved from \(from) to \(to)")
        }
    }
    
    private func castlingMove(piece: ChessPiece, move: ChessMove) -> ChessMoveEvent? {
        if piece.type == .king, piece.moveCalculator.moveCounter == 0 {
            switch piece.color {
            case .white:
                if move.to == "g1" {
                    return .castling(side: Castling.kingSide(.white))
                }
                if move.to == "c1" {
                    return .castling(side: Castling.queenSide(.white))
                }
            case .black:
                if move.to == "g8" {
                    return .castling(side: Castling.kingSide(.black))
                }
                if move.to == "c8" {
                    return .castling(side: Castling.queenSide(.black))
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
                    return .promotion(move: move, type: .queen)
                }
            case .black:
                if move.to.row == 1 {
                    return .promotion(move: move, type: .queen)
                }
            }
        }
        return nil
    }
    
    private func consume(_ event: ChessMoveEvent) {
        switch event {
        case .pieceMoved(_, let move):
            chessboard.move(move)
        case .pieceTakes(_, let move, _):
            chessboard.move(move)
        case .promotion(let move, _):
            chessboard.remove(move.to, move.from)
            chessboard.add(Queen(colorOnMove, move.to))
        case .castling(let castling):
            castling.moves.forEach { chessboard.move($0) }
        case .checkMate:
            break
        }
        eventHandler?(event)
    }
    
    func checkForGameOver() {
        for piece in chessboard.getPieces(color: colorOnMove) {
            if piece.moveCalculator.possibleMoves.count > 0 {
                return
            }
        }
        eventHandler?(.checkMate(colorOnMove.other))
    }
}
