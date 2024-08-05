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
        defer {
            colorOnMove = colorOnMove.other
        }
        if piece.type == .king, piece.moveCalculator.moveCounter == 0 {
            switch piece.color {
            case .white:
                if to == "g1", let rook = chessboard["h1"] {
                    // short castling
                    updateChessboardWithMove(piece: piece, from: "e1", to: "g1")
                    updateChessboardWithMove(piece: rook, from: "h1", to: "f1")
                    share(.pieceMoved(from: "e1", to: "g1"))
                    share(.pieceMoved(from: "h1", to: "f1"))
                }
                if to == "c1", let rook = chessboard["a1"] {
                    // short castling
                    updateChessboardWithMove(piece: piece, from: "e1", to: "c1")
                    updateChessboardWithMove(piece: rook, from: "a1", to: "d1")
                    share(.pieceMoved(from: "e1", to: "c1"))
                    share(.pieceMoved(from: "a1", to: "d1"))
                }
            case .black:
                if to == "g8", let rook = chessboard["h8"] {
                    // short castling
                    updateChessboardWithMove(piece: piece, from: "e8", to: "g8")
                    updateChessboardWithMove(piece: rook, from: "h8", to: "f8")
                    share(.pieceMoved(from: "e8", to: "g8"))
                    share(.pieceMoved(from: "h8", to: "f8"))
                }
                if to == "c8", let rook = chessboard["a8"] {
                    // short castling
                    updateChessboardWithMove(piece: piece, from: "e8", to: "c8")
                    updateChessboardWithMove(piece: rook, from: "a8", to: "d8")
                    share(.pieceMoved(from: "e8", to: "c8"))
                    share(.pieceMoved(from: "a8", to: "d8"))
                }
            }
        }
        let event: ChessBoardEvent!
        if let attackedPiece = chessboard[to] {
            event = .pieceTakes(from: from, to: to, killedType: attackedPiece.type)
            print("\(piece) moved from \(from) to \(to)")
        } else {
            event = .pieceMoved(from: from, to: to)
            print("\(piece) moved from \(from) to \(to)")
        }
        updateChessboardWithMove(piece: piece, from: from, to: to)
        share(event)
    }
    
    private func share(_ event: ChessBoardEvent) {
        status?(event)
        chessboard.broadcast(event: event)
    }

    private func updateChessboardWithMove(piece: ChessPiece, from: BoardSquare, to: BoardSquare) {
        let movedPiece = piece.moved(to: to)
        chessboard.pieces.removeAll { [to, from].contains($0.square) }
        chessboard.pieces.append(movedPiece)
    }
}
