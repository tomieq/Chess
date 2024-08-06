//
//  PawnMoveCalculator.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

class PawnMoveCalculator: MoveCalculator {
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
        var possiblePredators: [BoardSquare] = []
        
        // find all knight predators and defenders
        for position in square.knightMoves {
            if let piece = chessBoard.piece(at: position), piece.type == .knight {
                if piece.color == color {
                    defenders.append(piece.square)
                } else {
                    possiblePredators.append(piece.square)
                }
            }
        }
        
        // find all pawn predators and defenders
        let enemyPawnSearchDirection: [MoveDirection] = [.downLeft, .downRight, .upLeft, .upRight]
        for direction in enemyPawnSearchDirection {
            if let activePawn = chessBoard.activePawn(at: square.move(direction)),
               activePawn.attackedSquares.contains(square) {
                if activePawn.color == color {
                    defenders.append(activePawn.square)
                } else {
                    possiblePredators.append(activePawn.square)
                }
            }
        }
        
        var allowedDirections = MoveDirection.allCases
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
                        print("pawn at \(square) is pinned by \(piece.square)")
                        allowedDirections = allowedDirections.filter { $0 == direction || $0 == direction.opposite }
                    }
                }
            }
        }
        
        // find my king defender
        if let myKing = chessBoard.king(color: color), myKing.square.neighbours.contains(square) {
            defenders.append(myKing.square)
        }
        // find enemy king predator
        if let enemyKing = chessBoard.king(color: color.other), enemyKing.square.neighbours.contains(square) {
            possiblePredators.append(enemyKing.square)
        }

        if allowedDirections.contains(crawningDirection) {
            if let oneMove = square.move(crawningDirection) {
                if chessBoard.isFree(oneMove) {
                    possibleMoves.append(oneMove)
                    if isAtStartingSquare, let doubleMove = oneMove.move(crawningDirection) {
                        if chessBoard.isFree(doubleMove) {
                            possibleMoves.append(doubleMove)
                        }
                    }
                }
            }
        }
        for attackDirection in attackDirections where allowedDirections.contains(attackDirection) {
            if let attackedSquare = square.move(attackDirection),
               let piece = chessBoard.piece(at: attackedSquare) {
                if piece.color == color.other {
                    possibleMoves.append(attackedSquare)
                    possibleVictims.append(attackedSquare)
                } else {
                    defended.append(attackedSquare)
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
    
    var isAtStartingSquare: Bool {
        switch self.color {
        case .white:
            return self.square.row == 2
        case .black:
            return self.square.row == 7
        }
    }
    
    var crawningDirection: MoveDirection {
        switch self.color {
        case .white:
            return .up
        case .black:
            return .down
        }
    }
    
    var attackDirections: [MoveDirection] {
        switch self.color {
        case .white:
            return [.upLeft, .upRight]
        case .black:
            return [.downLeft, .downRight]
        }
    }
}
