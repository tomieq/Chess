//
//  ChessMoveExecutor+connect.swift
//  chess
//
//  Created by Tomasz Kucharski on 12/08/2024.
//
import chess
import Foundation
import ChessEngine

extension ChessMoveExecutor {
    func connect(to liveConnection: LiveConnection) {
        self.moveListener = { event in
            event.changes.forEach { change in
                switch change {
                case .move(let move):
                    guard let letter = chessBoard[move.to]?.letter else {
                        print("ERROR-move: At \(move.to) there is no piece!")
                        return
                    }
                    liveConnection.notifyClient(.removePiece(move.from))
                    liveConnection.notifyClient(.removePiece(move.to))
                    liveConnection.notifyClient(.addPiece(move.to, letter: letter))
                case .remove(_, _, let square):
                    liveConnection.notifyClient(.removePiece(square))
                case .add(_, _, let square):
                    guard let letter = chessBoard[square]?.letter else {
                        print("ERROR-add: At \(square) there is no piece!")
                        return
                    }
                    liveConnection.notifyClient(.addPiece(square, letter: letter))
                }
            }
            if event.status == .checkmate(winner: .white) || event.status == .checkmate(winner: .black) {
                liveConnection.notifyClient(.checkMate)
            }
            liveConnection.notifyClient(.whiteDump(chessBoard.dump(color: .white)))
            liveConnection.notifyClient(.blackDump(chessBoard.dump(color: .black)))
            LiveConnection.shared.notifyClient(.pgn(PgnUIView.html(chessBoard: chessBoard)))
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.100) {
                liveConnection.notifyClient(.fen(fenGenerator.fen))
            }
            if let (comment, color) = db.get(fenPosition: fenGenerator.fenPosition) {
                liveConnection.notifyClient(.comment(comment))
                liveConnection.notifyClient(.debug("Kolej \(color.plName)"))
            } else {
                liveConnection.notifyClient(.comment(""))
                liveConnection.notifyClient(.debug(""))
            }
        }
    }
}
