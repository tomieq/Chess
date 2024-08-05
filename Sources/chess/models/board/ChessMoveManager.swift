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

public class ChessMoveManager {
    let chessboard: ChessBoard
    public var colorOnMove: ChessPieceColor = .white
    public var status: ((ChessBoardEvent) -> Void)?
    
    public init(chessboard: ChessBoard) {
        self.chessboard = chessboard
    }
    
    public func move(from: BoardSquare?, to: BoardSquare?) throws {
        guard let from = from, let to = to else {
            print("Invalid square")
            throw ChessMoveError.invalidSquare
        }
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
        let movedPiece = piece.moved(to: to)
        chessboard.pieces.removeAll { [to, from].contains($0.square) }
        chessboard.pieces.append(movedPiece)
        status?(.pieceMoved(from: from, to: to))
        chessboard.broadcast(event: .pieceMoved(from: from, to: to))
        print("\(piece) moved from \(from) to \(to)")
        colorOnMove = colorOnMove.other
        
//        if chessboard.king(color: piece.color.other)?.moveCalculator.possiblePredators.isEmpty == false {
//            status?("Check!")
//        }
    }
}
