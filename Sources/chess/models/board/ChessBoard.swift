//
//  GameState.swift
//
//
//  Created by Tomasz on 11/09/2022.
//

import Foundation

typealias GamePiece = DetachedChessPiece & ChessPieceConvertible

public class ChessBoard {
    public var colorOnMove: ChessPieceColor = .white
    private var pieces: [ChessPiece]
    private var listeners: [(ChessBoardEvent) -> Void] = []
    var allPieces: [ChessPiece] {
        self.pieces
    }

    public init() {
        self.pieces = []
    }

    private init(pieces: [ChessPiece]) {
        self.pieces = pieces
    }
    
    func subscribe(subscriber: @escaping (ChessBoardEvent) -> Void) {
        self.listeners.append(subscriber)
    }
    
    private func broadcast(event: ChessBoardEvent) {
        listeners.forEach { $0(event) }
    }
    
    @discardableResult
    func add(_ piece: GamePiece?) -> ChessBoard {
        self.addPiece(piece)
        return self
    }

    func add(_ pieces: GamePiece?...) {
        for piece in pieces {
            self.addPiece(piece, emitChanges: false)
        }
        let squares = pieces.compactMap{ $0?.square }
        broadcast(event: .pieceAdded(at: squares))
    }
    
    func remove(_ square: BoardSquare) {
        self.pieces = self.pieces.filter{ $0.square != square }
        broadcast(event: .pieceRemoved(from: square))
    }
    
    func remove(_ squares: BoardSquare...) {
        self.pieces = self.pieces.filter{ !squares.contains($0.square) }
        squares.forEach { broadcast(event: .pieceRemoved(from: $0))  }
        
    }

    func move(_ move: ChessBoardMove) {
        guard let movedPiece = piece(at: move.from)?.moved(to: move.to) else { return }
        pieces.removeAll { [move.to, move.from].contains($0.square) }
        pieces.append(movedPiece)
        broadcast(event: .pieceMoved(move))
    }
    
    private func addPiece(_ piece: GamePiece?, emitChanges: Bool = true) {
        if let chessPiece = piece?.chessPiece(chessBoard: self) {
            self.pieces.append(chessPiece)
            if emitChanges {
                broadcast(event: .pieceAdded(at: [chessPiece.square]))
            }
        }
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

    func isCheck(for color: ChessPieceColor) -> Bool {
        if let king = king(color: color), !king.moveCalculator.possibleAttackers.isEmpty {
            return true
        }
        return false
    }
    
    func isCheckMate(for color: ChessPieceColor) -> Bool {
        for piece in getPieces(color: color) {
            if piece.moveCalculator.possibleMoves.count > 0 {
                return false
            }
        }
        return true
    }
    
    var status: ChessGameStatus {
        for color in ChessPieceColor.allCases {
            if isCheckMate(for: color) {
                print("It is checkmate for \(color)")
                return .checkmate
            }
            if isCheck(for: color) {
                print("It is check for \(color) possible moves: \(getPieces(color: color).filter{ $0.moveCalculator.possibleMoves.isEmpty.not }.map{ "\($0) moves: \($0.moveCalculator.possibleMoves)" }.joined(separator: ", "))")
                return .check
            }
        }
        return .normal
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
}
