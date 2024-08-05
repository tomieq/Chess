//
//  GameState.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

typealias GamePiece = DetachedChessPiece & ChessPieceConvertible

public enum ChessBoardError: Error {
    case invalidSquare
    case noPiece(at: BoardSquare)
    case colorOnMove(ChessPieceColor)
    case canNotMove(to: BoardSquare)
}

enum ChessBoardEvent {
    case pieceAdded(at: [BoardSquare])
    case pieceMoved(from: BoardSquare, to: BoardSquare)
}

public class ChessBoard {
    var pieces: [ChessPiece]
    var colorOnMove: ChessPieceColor = .white
    private var listeners: [(ChessBoardEvent) -> Void] = []

    public init() {
        self.pieces = []
    }

    private init(pieces: [ChessPiece]) {
        self.pieces = pieces
    }
    
    public func move(from: BoardSquare?, to: BoardSquare?) throws {
        guard let from = from, let to = to else {
            print("Invalid square")
            throw ChessBoardError.invalidSquare
        }
        guard let piece = self[from] else {
            print("No piece at \(from)")
            throw ChessBoardError.noPiece(at: from)
        }
        guard piece.color == colorOnMove else {
            print("Cannot move with \(piece) as now only \(colorOnMove) can move now")
            throw ChessBoardError.colorOnMove(colorOnMove)
        }
        guard piece.moveCalculator.possibleMoves.contains(to) else {
            print("\(piece) cannot move to \(to). It can move only to \(piece.moveCalculator.possibleMoves)")
            throw ChessBoardError.canNotMove(to: to)
        }
        let movedPiece = piece.moved(to: to)
        pieces.removeAll { [to, from].contains($0.square) }
        pieces.append(movedPiece)
        broadcastChanges(.pieceMoved(from: from, to: to))
        print("\(piece) moved from \(from) to \(to)")
        colorOnMove = colorOnMove.other
    }
    
    func subscribe(subscriber: @escaping (ChessBoardEvent) -> Void) {
        self.listeners.append(subscriber)
    }
    
    private func broadcastChanges(_ event: ChessBoardEvent) {
        listeners.forEach { $0(event) }
    }

    @discardableResult
    func addPiece(_ piece: GamePiece?, emitChanges: Bool = true) -> ChessBoard {
        if let chessPiece = piece?.chessPiece(chessBoard: self) {
            self.pieces.append(chessPiece)
            if emitChanges {
                broadcastChanges(.pieceAdded(at: [chessPiece.square]))
            }
        }
        return self
    }

    func addPieces(_ pieces: GamePiece?...) {
        for piece in pieces {
            self.addPiece(piece, emitChanges: false)
        }
        let squares = pieces.compactMap{ $0?.square }
        broadcastChanges(.pieceAdded(at: squares))
    }

    func piece(at square: BoardSquare?) -> ChessPiece? {
        self.pieces.first{ $0.square == square }
    }
    
    public subscript(square: BoardSquare?) -> ChessPiece? {
        set {}
        get {
            piece(at: square)
        }
    }

    func activePawn(at square: BoardSquare?) -> ActivePawn? {
        guard let piece = self.piece(at: square), piece.type == .pawn else { return nil }
        return ActivePawn(color: piece.color, square: piece.square)
    }

    func king(color: ChessPieceColor) -> ChessPiece? {
        self.pieces.first { $0.type == .king && $0.color == color }
    }

    func isFree(_ square: BoardSquare) -> Bool {
        !self.pieces.contains{ $0.square == square }
    }

    @discardableResult
    public func setupGame() -> ChessBoard {
        let chessboardLoader = ChessBoardLoader(chessBoads: self)
        chessboardLoader
            .load(.white, "Ra1 Nb1 Bc1 Qd1 Ke1 Bf1 Ng1 Rh1")
            .load(.white, "a2 b2 c2 d2 e2 f2 g2 h2")
            .load(.black, "Ra8 Nb8 Bc8 Qd8 Ke8 Bf8 Ng8 Rh8")
            .load(.black, "a7 b7 c7 d7 e7 f7 g7 h7")
        broadcastChanges(.pieceAdded(at: []))
        return self
    }

    func getPieces(color: ChessPieceColor) -> [ChessPiece] {
        self.pieces.filter{ $0.color == color }
    }

//    func remove(_ square: BoardSquare) {
//        self.pieces = self.pieces.filter{ $0.square != square }
//        broadcastChanges()
//    }
}
