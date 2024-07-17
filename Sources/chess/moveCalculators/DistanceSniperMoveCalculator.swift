//
//  DistanceSniperMoveCalculator.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

class DistanceSniperMoveCalculator: MoveCalculator {
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
    private let longDistanceAttackDirections: [MoveDirection]
    
    init(for piece: DetachedChessPiece, on chessBoard: ChessBoard, longDistanceAttackDirections: [MoveDirection]) {
        self.square = piece.square
        self.color = piece.color
        self.chessBoard = chessBoard
        self.longDistanceAttackDirections = longDistanceAttackDirections
        self.chessBoard.subscribe { [weak self] in
            self?.gameChanged()
        }
    }
    
    private func gameChanged() {
        self.isAnalized = false
    }
    
    private func analize() {
        var possibleMoves: [BoardSquare] = []
        var backedUpFriends: [BoardSquare] = []
        var possibleVictims: [BoardSquare] = []
        var possiblePredators: [BoardSquare] = []
        var allowedDirections = self.longDistanceAttackDirections
        
        // check if move is pinned
        for direction in MoveDirection.allCases {
            if let nearestPiece = self.nearestPiece(in: direction), 
                nearestPiece.longDistanceAttackDirections.contains(direction) {
                possiblePredators.append(nearestPiece.square)
                if let oppositeDirectionPiece = self.nearestPiece(in: direction.opposite),
                  oppositeDirectionPiece.color == self.color, oppositeDirectionPiece.type == .king {
                   print("piece at \(square) is pinned by \(nearestPiece.square)")
                   allowedDirections = allowedDirections.filter { $0 == direction || $0 == direction.opposite }
                }
            }
        }
        
        for direction in allowedDirections {
            for position in square.squares(to: direction) {
                if let piece = chessBoard.piece(at: position) {
                    if piece.color == self.color {
                        backedUpFriends.append(position)
                    } else {
                        possibleVictims.append(position)
                        possibleMoves.append(position)
                    }
                    break
                } else {
                    possibleMoves.append(position)
                }
            }
        }
        self.calculatedMoves = CalculatedMoves(possibleMoves: possibleMoves,
                                               possibleVictims: possibleVictims,
                                               backedUpFriends: backedUpFriends,
                                               possiblePredators: possiblePredators)
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
