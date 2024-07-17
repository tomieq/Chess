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
    
    var backedUpFriends: [BoardSquare] {
        get {
            if !isAnalized {
                analize()
            }
            return calculatedMoves.backedUpFriends
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
        var supports: [BoardSquare] = []
        var attacks: [BoardSquare] = []
        var attackedBy: [BoardSquare] = []
        
        var allowedSquares = square.knightMoves
        // check if move is pinned
        for direction in MoveDirection.allCases {
            if let nearestPiece = self.nearestPiece(in: direction), nearestPiece.longDistanceAttackDirections.contains(direction) {
                attackedBy.append(nearestPiece.square)
                if let oppositeDirectionPiece = self.nearestPiece(in: direction.opposite),
                  oppositeDirectionPiece.color == self.color, oppositeDirectionPiece.type == .king {
                    print("knight at \(square) is pinned by \(nearestPiece.square)")
                    allowedSquares = []
                }
            }
        }
        
        for position in allowedSquares {
            if let piece = chessBoard.piece(at: position) {
                if piece.color == self.color {
                    supports.append(position)
                } else {
                    attacks.append(position)
                    possibleMoves.append(position)
                }
            } else {
                possibleMoves.append(position)
            }
        }
        
        self.calculatedMoves = CalculatedMoves(possibleMoves: possibleMoves,
                                               possibleVictims: attacks,
                                               backedUpFriends: supports,
                                               possiblePredators: attackedBy)
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
}
