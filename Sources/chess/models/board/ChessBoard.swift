//
//  GameState.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

typealias GamePiece = DetachedChessPiece & ChessPieceConvertible

public enum ChessBoardEvent {
    case pieceAdded(at: [BoardSquare])
    case pieceMoved(from: BoardSquare, to: BoardSquare)
}

public class ChessBoard {
    var pieces: [ChessPiece]
    private var listeners: [(ChessBoardEvent) -> Void] = []

    public init() {
        self.pieces = []
    }

    private init(pieces: [ChessPiece]) {
        self.pieces = pieces
    }
    
    func subscribe(subscriber: @escaping (ChessBoardEvent) -> Void) {
        self.listeners.append(subscriber)
    }
    
    func broadcast(event: ChessBoardEvent) {
        listeners.forEach { $0(event) }
    }

    @discardableResult
    func addPiece(_ piece: GamePiece?, emitChanges: Bool = true) -> ChessBoard {
        if let chessPiece = piece?.chessPiece(chessBoard: self) {
            self.pieces.append(chessPiece)
            if emitChanges {
                broadcast(event: .pieceAdded(at: [chessPiece.square]))
            }
        }
        return self
    }

    func addPieces(_ pieces: GamePiece?...) {
        for piece in pieces {
            self.addPiece(piece, emitChanges: false)
        }
        let squares = pieces.compactMap{ $0?.square }
        broadcast(event: .pieceAdded(at: squares))
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
        broadcast(event: .pieceAdded(at: []))
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
