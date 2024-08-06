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
    
    var possibleAttackers: [BoardSquare] {
        get {
            if !isAnalized {
                analize()
            }
            return calculatedMoves.possibleAttackers
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
        self.chessBoard.subscribe { [weak self] event in
            self?.gameChanged(event)
        }
    }
    
    private func gameChanged(_ event: ChessBoardEvent) {
        switch event {
        case .pieceMoved(let move):
            if self.square == move.from {
                self.square = move.to
            }
        default:
            break
        }
        self.isAnalized = false
    }
    
    private func analize() {
        var possibleMoves: [BoardSquare] = []
        var defended: [BoardSquare] = []
        var defenders: [BoardSquare] = []
        var possibleVictims: [BoardSquare] = []
        var possibleAttackers: [BoardSquare] = []
        var allowedDirections = self.longDistanceAttackDirections
        
        // find all knight attackers and defenders
        for position in square.knightMoves {
            if let piece = chessBoard.piece(at: position), piece.type == .knight {
                if piece.color == color {
                    defenders.append(piece.square)
                } else {
                    possibleAttackers.append(piece.square)
                }
            }
        }
        
        // find all pawn attackers and defenders
        let enemyPawnSearchDirection: [MoveDirection] = [.downLeft, .downRight, .upLeft, .upRight]
        for direction in enemyPawnSearchDirection {
            if let activePawn = chessBoard.activePawn(at: square.move(direction)),
               activePawn.attackedSquares.contains(square) {
                if activePawn.color == color {
                    defenders.append(activePawn.square)
                } else {
                    possibleAttackers.append(activePawn.square)
                }
            }
        }
        // find my king defender
        if let myKing = chessBoard.king(color: color), myKing.square.neighbours.contains(square) {
            defenders.append(myKing.square)
        }
        // find enemy king attacker
        if let enemyKing = chessBoard.king(color: color.other), enemyKing.square.neighbours.contains(square) {
            possibleAttackers.append(enemyKing.square)
        }

        // check if move is pinned and update defenders and attackers
        for direction in MoveDirection.allCases {
            for piece in pieces(in: direction) {
                guard piece.longDistanceAttackDirections.contains(direction) else {
                    break
                }
                if piece.color == self.color {
                    defenders.append(piece.square)
                } else {
                    possibleAttackers.append(piece.square)
                    if let oppositeDirectionPiece = self.nearestPiece(in: direction.opposite),
                       oppositeDirectionPiece.color == self.color, oppositeDirectionPiece.type == .king {
                        print("piece at \(square) is pinned by \(piece.square)")
                        allowedDirections = allowedDirections.filter { $0 == direction || $0 == direction.opposite }
                    }
                }
            }
        }
        
        for direction in allowedDirections {
            for position in square.squares(to: direction) {
                if let piece = chessBoard.piece(at: position) {
                    if piece.color == self.color {
                        defended.append(position)
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
        // if king is atacked twice, you cannot cover, so it is king who must escape
        if let king = chessBoard.king(color: color), king.moveCalculator.possibleAttackers.count > 1 {
            possibleMoves = []
        }
        self.calculatedMoves = CalculatedMoves(possibleMoves: possibleMoves,
                                               possibleVictims: possibleVictims,
                                               possibleAttackers: possibleAttackers,
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
