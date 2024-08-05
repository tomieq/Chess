//
//  KingMoveCalculator.swift
//
//
//  Created by Tomasz Kucharski on 17/07/2024.
//

import Foundation

class KingMoveCalculator: MoveCalculator {
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
        case .pieceMoved(let from, let to), .pieceTakes(let from, let to, _):
            if self.square == from {
                self.square = to
            }
        default:
            break
        }
        self.isAnalized = false
    }
    
    private func predatorsFor(square: BoardSquare) -> [BoardSquare] {
        var predators: [BoardSquare] = []
        // find all knight predators and defenders
        for position in square.knightMoves {
            if let piece = chessBoard.piece(at: position), piece.type == .knight, piece.color == color.other  {
                predators.append(piece.square)
            }
        }
        // find enemy king predator
        if let enemyKing = chessBoard.king(color: color.other), enemyKing.square.neighbours.contains(square) {
            predators.append(enemyKing.square)
        }
        
        // find all pawn predators and defenders
        let enemyPawnSearchDirection: [MoveDirection] = [.downLeft, .downRight, .upLeft, .upRight]
        for direction in enemyPawnSearchDirection {
            if let activePawn = chessBoard.activePawn(at: square.move(direction)), activePawn.color == color.other,
               activePawn.attackedSquares.contains(square) {
                predators.append(activePawn.square)
            }
        }
        // check long distance hitters
        for direction in MoveDirection.allCases {
            for piece in pieces(in: direction, from: square) {
                guard piece.color == color.other, piece.longDistanceAttackDirections.contains(direction) else {
                    break
                }
                predators.append(piece.square)
            }
        }
        return predators
    }

    private func analize() {
        var possibleMoves: [BoardSquare] = []
        var defended: [BoardSquare] = []
        let defenders: [BoardSquare] = []
        var possibleVictims: [BoardSquare] = []
        var possiblePredators: [BoardSquare] = []
        
        let allowedSquares = square.neighbours
        
        for position in allowedSquares {
            if let piece = chessBoard.piece(at: position) {
                if piece.color == color {
                    defended.append(piece.square)
                } else {
                    possibleVictims.append(piece.square)
                    if predatorsFor(square: piece.square).isEmpty {
                        possibleMoves.append(piece.square)
                    }
                }
            } else {
                if predatorsFor(square: position).isEmpty {
                    possibleMoves.append(position)
                }
            }
        }
        possiblePredators = predatorsFor(square: square)
        
        // castling
        if moveCounter == 0, square == startingSquare {
            if rookCanCastle(at: BoardSquare(.a, square.row)) {
                possibleMoves.append(BoardSquare(.c, square.row)!)
            }
            if rookCanCastle(at: BoardSquare(.h, square.row)) {
                possibleMoves.append(BoardSquare(.g, square.row)!)
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
    
    private func pieces(in direction: MoveDirection, from square: BoardSquare) -> [ChessPiece] {
        var pieces: [ChessPiece] = []
        for position in square.squares(to: direction) {
            if let piece = chessBoard.piece(at: position) {
                pieces.append(piece)
            }
        }
        return pieces
    }
    
    private var startingSquare: BoardSquare {
        switch color {
        case .white:
            "e1"
        case .black:
            "e8"
        }
    }
    
    private func rookCanCastle(at square: BoardSquare?) -> Bool {
        guard let rook = chessBoard.piece(at: square), rook.type == .rook,
              rook.color == color, rook.moveCalculator.moveCounter == 0 else {
            return false
        }
        let side: MoveDirection = self.square.column > rook.square.column ? .left : .right
        let wayToCrawl = self.square.squares(to: side).dropLast(1)
        guard wayToCrawl.map({ chessBoard.isFree($0) }).allSatisfy({ $0 }) else {
            return false
        }
        guard wayToCrawl.map( { predatorsFor(square: $0).isEmpty }).allSatisfy( { $0 }) else {
            return false
        }
        return true
    }
}
