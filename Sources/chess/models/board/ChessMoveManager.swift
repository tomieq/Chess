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
    case canNotMove(to: BoardSquare)
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
            throw ChessMoveError.canNotMove(to: to)
        }
        defer {
            colorOnMove = colorOnMove.other
            checkForGameOver()
        }
        if promotionMove(piece: piece, move: move) { return }
        if castlingMove(piece: piece, move: move) { return }
        let event: ChessMoveEvent!
        if let attackedPiece = chessboard[to] {
            event = .pieceTakes(type: piece.type, move: move, takenType: attackedPiece.type)
            print("\(piece.color) \(piece.type.enName) from \(from) took \(attackedPiece)")
        } else {
            event = .pieceMoved(type: piece.type, move: move)
            print("\(piece.color) \(piece.type.enName) moved from \(from) to \(to)")
        }
        chessboard.move(move)
        eventHandler?(event)
    }
    
    private func castlingMove(piece: ChessPiece, move: ChessMove) -> Bool {
        if piece.type == .king, piece.moveCalculator.moveCounter == 0 {
            switch piece.color {
            case .white:
                if move.to == "g1" {
                    let castling = Castling.kingSide(.white)
                    castling.moves.forEach { chessboard.move($0) }
                    eventHandler?(.castling(side: castling))
                    return true
                }
                if move.to == "c1" {
                    let castling = Castling.queenSide(.white)
                    castling.moves.forEach { chessboard.move($0) }
                    eventHandler?(.castling(side: castling))
                    return true
                }
            case .black:
                if move.to == "g8" {
                    let castling = Castling.kingSide(.black)
                    castling.moves.forEach { chessboard.move($0) }
                    eventHandler?(.castling(side: castling))
                    return true
                }
                if move.to == "c8" {
                    let castling = Castling.queenSide(.black)
                    castling.moves.forEach { chessboard.move($0) }
                    eventHandler?(.castling(side: castling))
                    return true
                }
            }
            
        }
        return false
    }
    
    private func promotionMove(piece: ChessPiece, move: ChessMove) -> Bool {
        if piece.type == .pawn {
            switch piece.color {
            case .white:
                if move.to.row == 8, let queen = Queen(piece.color, move.to) {
                    chessboard.remove(move.to, move.from)
                    chessboard.add(queen)
                    eventHandler?(.promotion(move: move, type: .queen))
                    return true
                }
            case .black:
                if move.to.row == 1, let queen = Queen(piece.color, move.to) {
                    chessboard.remove(move.to, move.from)
                    chessboard.add(queen)
                    eventHandler?(.promotion(move: move, type: .queen))
                    return true
                }
            }
        }
        return false
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
