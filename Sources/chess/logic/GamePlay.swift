//
//  GamePlay.swift
//
//
//  Created by Tomasz on 06/04/2023.
//

import Foundation
/*
class GamePlay {
    private let chessBoard: ChessBoard
    //private let moveCalculator: MoveCalculator
    private var turnColor: ChessPieceColor
    private var possibleMoves: [ChessPieceColor: [ChessPiece: PossibleMoves]] = [:]
    private var moveCounter = 1

    var moveCounterInfo: String {
        "\(self.moveCounter).\(self.turnColor == .black ? "." : "")"
    }

    var dump: String {
        self.chessBoard.dump
    }

    init() {
        self.chessBoard = ChessBoard()
        //self.moveCalculator = MoveCalculator(chessBoard: self.chessBoard)
        self.turnColor = .white
    }

    func start() {
        self.chessBoard.setupGame()
        self.updatePossibleMoves()
    }

    func play(gameplay: String) {
        gameplay.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .forEach { self.nextMove($0) }
    }

    func setPieces(_ color: ChessPieceColor, _ txt: String) {
        ChessBoardLoader(chessBoads: self.chessBoard).load(color, txt)
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
                    //guard color == self.turnColor.other else { continue }
                    for agressive in possibleMoves.agressive {
                        guard let inDanger = self.chessBoard.getPiece(agressive) else { continue }
                        
                        var info = "  🧠 \(Text["analysisDanger"].with(piece, inDanger.type.plName, agressive))"
                        //let backup = self.moveCalculator.backup(for: agressive)
                        let backup = possibleMoves.covers.compactMap { self.moveCalculator.chessBoard.getPiece($0) }
                        if !backup.isEmpty {
                            let times = backup.count > 1 ? Text["timesx\(backup.count)"] : ""
                            info.append(", ale ma on \(times) wsparcie od \(backup.map{ "\($0.type.plName) z \($0.square)" }.joined(separator: " oraz "))")
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
        if move.starts(with: "O-O") {
            self.castlingMove(color: color, move: move, language: language)
            return
        }

        var square: BoardSquare?
        var piece: ChessPiece?
        if move.count == 2 {
            square = BoardSquare(stringLiteral: move)
            piece = self.possibleMoves[color]?.first { $0.key.type == .pawn && $0.value.passive.contains(square!) }.map { $0.key }
        } else {
            guard let detectedType = ChessPieceType.make(letter: move.subString(0, 1), language: language) else {
                print("❗Could not detect piece type from letter \(move.subString(0, 1))")
                return
            }
            if move.count == 3 {
                square = BoardSquare(stringLiteral: move.subString(1, 3))
                piece = self.possibleMoves[color]?.first { $0.key.type == detectedType && $0.value.passive.contains(square!) }.map { $0.key }
            } else if move.count == 4 {
                let column = move.subString(1, 2)
                square = BoardSquare(stringLiteral: move.subString(2, 4))
                piece = self.possibleMoves[color]?.first { $0.key.type == detectedType && $0.key.square.column.letter == column.first && $0.value.passive.contains(square!) }.map { $0.key }
            } else {
                print("error")
            }
        }

        guard let piece = piece, let square = square else {
            print("❗Movement to \(move) for \(color) is not possible")
            return
        }
        if self.chessBoard.isSquareFree(square) {
            print("\(self.moveCounterInfo) (\(move)) - \(piece.color.plName) \(piece.type.plName) z \(piece.square) rusza się na \(square)")
            self.chessBoard.move(source: piece.square, to: square)
        } else {
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

    private func castlingMove(color: ChessPieceColor, move: String, language: Language) {
        guard let king = self.chessBoard.getKing(color: color) as? King else {
            print("❗Could not find king for \(color) castling")
            return
        }
        let possibleMoves = self.moveCalculator.kingMoves(king, calculation: .deep)
        switch move {
        case "O-O":
            switch color {
            case .white:
                guard possibleMoves?.passive.contains("g1") == true else {
                    print("❗\(color) king can't castle!")
                    return
                }
                self.chessBoard.move(source: king.square, to: "g1")
                self.chessBoard.move(source: "h1", to: "f1")
            case .black:
                guard possibleMoves?.passive.contains("g8") == true else {
                    print("❗\(color) king can't castle!")
                    return
                }
                self.chessBoard.move(source: king.square, to: "g8")
                self.chessBoard.move(source: "h8", to: "f8")
            }
            print("\(self.moveCounterInfo) \(color.plName) \(king.type.plName) robi krótką roszadę")
        case "O-O-O":
            switch color {
            case .white:
                guard possibleMoves?.passive.contains("c1") == true else {
                    print("❗\(color) king can't castle!")
                    return
                }
                self.chessBoard.move(source: king.square, to: "c1")
                self.chessBoard.move(source: "a1", to: "d1")
            case .black:
                guard possibleMoves?.passive.contains("c8") == true else {
                    print("❗\(color) king can't castle!")
                    return
                }
                self.chessBoard.move(source: king.square, to: "c8")
                self.chessBoard.move(source: "a8", to: "d8")
            }
            print("\(self.moveCounterInfo) \(color.plName) \(king.type.plName) robi długą roszadę")
        default:
            print("❗Invalid command \(move) for castling")
        }
    }
}
*/
