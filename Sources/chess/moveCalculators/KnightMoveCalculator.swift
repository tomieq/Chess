//
//  KnightMoveCalculator.swift
//  
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

class KnightMoveCalculator: MoveCalculator {
    var moveCounter: Int = 0
    private var isAnalized = false
    private var calculatedMoves = CalculatedMoves.default
    
    var possibleMoves: [BoardSquare] {
        get {
            if !isAnalized {
                analize()
            }
            return calculatedMoves.possibleMoves
        }
    }

    var possibleVictims: [BoardSquare] {
        get {
            if !isAnalized {
                analize()
            }
            return calculatedMoves.possibleVictims
        }
    }
    
    var defended: [BoardSquare] {
        get {
            if !isAnalized {
                analize()
            }
            return calculatedMoves.defended
        }
    }
    
    var defenders: [BoardSquare] {
        get {
            if !isAnalized {
                analize()
            }
            return calculatedMoves.defenders
        }
    }
    
    var possiblePredators: [BoardSquare] {
        get {
            if !isAnalized {
                analize()
            }
            return calculatedMoves.possiblePredators
        }
    }
    
    let chessBoard: ChessBoard
    private var square: BoardSquare
    private var color: ChessPieceColor
    
    init(for piece: DetachedChessPiece, on chessBoard: ChessBoard) {
        self.square = piece.square
        self.color = piece.color
        self.chessBoard = chessBoard
        self.chessBoard.subscribe { [weak self] in
            self?.gameChanged()
        }
    }
    
    private func gameChanged() {
        self.isAnalized = false
    }
    
    private func analize() {
        var possibleMoves: [BoardSquare] = []
        var defended: [BoardSquare] = []
        var defenders: [BoardSquare] = []
        var possibleVictims: [BoardSquare] = []
        var possiblePredators: [BoardSquare] = []
        
        var allowedSquares = square.knightMoves
        // check if move is pinned and update defenders and predators
        for direction in MoveDirection.allCases {
            for piece in pieces(in: direction) {
                guard piece.longDistanceAttackDirections.contains(direction) else {
                    break
                }
                if piece.color == self.color {
                    defenders.append(piece.square)
                } else {
                    possiblePredators.append(piece.square)
                    if let oppositeDirectionPiece = self.nearestPiece(in: direction.opposite),
                       oppositeDirectionPiece.color == self.color, oppositeDirectionPiece.type == .king {
                        print("knight at \(square) is pinned by \(piece.square)")
                        allowedSquares = []
                    }
                }
            }
        }
        
        for position in allowedSquares {
            if let piece = chessBoard.piece(at: position) {
                if piece.color == self.color {
                    defended.append(position)
                } else {
                    possibleVictims.append(position)
                    possibleMoves.append(position)
                }
            } else {
                possibleMoves.append(position)
            }
        }

        for position in square.knightMoves {
            if let piece = chessBoard.piece(at: position), piece.type == .knight {
                if piece.color == color {
                    defenders.append(piece.square)
                } else {
                    possiblePredators.append(piece.square)
                }
            }
        }
        
        self.calculatedMoves = CalculatedMoves(possibleMoves: possibleMoves,
                                               possibleVictims: possibleVictims,
                                               possiblePredators: possiblePredators,
                                               defended: defended,
                                               defenders: defenders)
        self.isAnalized = true
    }

    private func nearestPiece(in direction: MoveDirection) -> ChessPiece? {
        for position in square.squares(to: direction) {
            if let piece = chessBoard.piece(at: position) {
                return piece
            }
        }
        return nil
    }
    
    private func pieces(in direction: MoveDirection) -> [ChessPiece] {
        var pieces: [ChessPiece] = []
        for position in square.squares(to: direction) {
            if let piece = chessBoard.piece(at: position) {
                pieces.append(piece)
            }
        }
        return pieces
    }
}
