//
//  GamePlay.swift
//
//
//  Created by Tomasz on 06/04/2023.
//

import Foundation

class GamePlay {
    private let chessBoard: ChessBoard
    private let moveCalculator: MoveCalculator
    private var turnColor: ChessPieceColor
    private var possibleMoves: [ChessPieceColor: [ChessPiece: PossibleMoves]] = [:]
    private var moveCounter = 1

    var moveCounterInfo: String {
        "\(self.moveCounter).\(self.turnColor == .black ? "." : "")"
    }

    init() {
        self.chessBoard = ChessBoard()
        self.moveCalculator = MoveCalculator(chessBoard: self.chessBoard)
        self.turnColor = .white
    }

    func start() {
        self.chessBoard.setupGame()
        self.updatePossibleMoves()
    }

    func nextMove(_ move: String, language: Language = .polish) {
        let parts = move.components(separatedBy: .whitespaces)
        self.move(color: self.turnColor, move: parts[0], language: language)
        self.updatePossibleMoves()
        self.turnColor = self.turnColor.other
        if parts.count > 1 {
            self.move(color: self.turnColor, move: parts[1], language: language)
            self.updatePossibleMoves()
            self.turnColor = self.turnColor.other
        }
    }

    private func updatePossibleMoves() {
        self.possibleMoves = [:]
        for color in ChessPieceColor.allCases {
            let pieces = self.moveCalculator.chessBoard.getPieces(color: color)
            for piece in pieces {
                if let possibleMoves = self.moveCalculator.possibleMoves(from: piece.square) {
                    self.possibleMoves[color, default: [:]][piece] = possibleMoves
                    guard color == self.turnColor.other else { continue }
                    for agressive in possibleMoves.agressive {
                        guard let inDanger = self.chessBoard.getPiece(agressive) else { continue }
                        var info = "  🧠 \(piece.color.plName) \(piece.type.plName) z \(piece.square) może zbić \(inDanger.type.plName) na \(agressive)"
                        let backup = self.moveCalculator.backup(for: agressive)
                        if !backup.isEmpty {
                            info.append(", ale ma on wsparcie od \(backup.map{ "\($0.type.plName) z \($0.square)" }.joined(separator: " oraz "))")
                        }
                        print(info)
                    }
                }
            }
        }
    }

    private func move(color: ChessPieceColor, move: String, language: Language) {
        let move = move.trimmingCharacters(in: .whitespacesAndNewlines)
        defer {
            if self.turnColor == .black {
                self.moveCounter += 1
            }
        }
        if move.contains("x") {
            self.takeDownMove(color: color, move: move, language: language)
            return
        }

        var type: ChessPieceType = .pawn
        var square = move
        if move.count == 3 {
            guard let detectedType = ChessPieceType.make(letter: move.subString(0, 1), language: language) else {
                print("❗Could not detect piece type from letter \(move.subString(0, 1))")
                return
            }
            type = detectedType
            square = move.subString(1, 3)
        }
        let destSquare = BoardSquare(stringLiteral: square)

        if self.chessBoard.isSquareFree(destSquare) {
            // normal move
            let piece = self.possibleMoves[color]?.first { $0.key.type == type && $0.value.passive.contains(destSquare) }.map { $0.key }
            guard let piece = piece else {
                print("❗Movement to \(move) for \(color) is not possible")
                return
            }
            print("\(self.moveCounterInfo) \(piece.color.plName) \(piece.type.plName) z \(piece.square) rusza się na \(destSquare)")
            self.chessBoard.move(source: piece.square, to: destSquare)
        } else {
            // agressive move
            print("❗Movement to \(move) for \(color) is not possible as field \(square) is taken")
        }
    }

    private func takeDownMove(color: ChessPieceColor, move: String, language: Language) {
        let parts = move.components(separatedBy: "x")
        guard parts.count == 2 else {
            print("❗Invalid \(move)")
            return
        }
        let firstLetter = parts[0].subString(0, 1)
        let type = ChessPieceType.make(letter: firstLetter, language: language) ?? .pawn
        let square = BoardSquare(stringLiteral: parts[1])

        var piece: ChessPiece?
        let potencialPieces = self.possibleMoves[color]?.filter { $0.key.type == type && $0.value.agressive.contains(square) }.map { $0.key }
        switch type {
        case .pawn:
            piece = potencialPieces?.first{ $0.square.column.letter == firstLetter.first }
        default:
            piece = potencialPieces?.first
        }

        guard let attacker = piece else {
            print("❗Could not find \(type) for move \(move) for \(color) to take \(square)")
            return
        }
        print("\(self.moveCounterInfo) \(attacker.color.plName) \(attacker.type.plName) z \(attacker.square) bije na \(square)")
        self.chessBoard.move(source: attacker.square, to: square)
    }
}
