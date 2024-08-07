//
//  ChessMoveExecutor.swift
//  chess
//
//  Created by Tomasz Kucharski on 07/08/2024.
//

// ChessMoveExecutor updates the chessboard according to incoming ChessMoveCommand
// It stores moves in order to be able ro reverse them
// It also produces ChessMove events so external UI can be updated (moveListener)

public class ChessMoveExecutor {
    let chessboard: ChessBoard
    public var moveListener: ((ChessMove) -> Void)?
    var moveStack: [ChessMove] = []
    
    public init(chessboard: ChessBoard) {
        self.chessboard = chessboard
    }

    public func process(_ command: ChessMoveCommand) {
        defer {
            chessboard.colorOnMove = chessboard.colorOnMove.other
        }
        let color = chessboard.colorOnMove
        switch command {
        case .move(let move, let promotion):
            print("\(color) move \(chessboard[move.from]!.type) \(move)")
            var changes: [ChessMove.Change] = []
            // with promotion
            if let promotedType = promotion {
                // build changes
                changes.append(.remove(.pawn, color, from: move.from))
                changes.append(.add(promotedType, color, to: move.to))
                // update the local board
                chessboard.remove(move.from)
                chessboard.add(promotedType.gamePiece(color: color, square: move.to))
            } else {
                // build changes
                changes.append(.move(move))
                // update the local board
                chessboard.move(move)
            }
            // store history
            register(ChessMove(color: color,
                               notation: "",
                               changes: changes,
                               status: chessboard.status(for: color)))
        case .take(let move, let promotion):
            print("\(chessboard[move.from]!) take \(chessboard[move.from]!.type) on \(move)")
            var changes: [ChessMove.Change] = []
            if let removedPiece = chessboard[move.to] {
                changes.append(.remove(removedPiece.type, removedPiece.color, from: move.to))
            }
            if let promotedType = promotion {
                // build changes
                changes.append(.remove(.pawn, color, from: move.from))
                changes.append(.add(promotedType, color, to: move.to))
                // update the local board
                chessboard.remove(move.to, move.from)
                chessboard.add(Queen(chessboard.colorOnMove, move.to))
            } else {
                // build changes
                changes.append(.move(move))
                // update the local board
                chessboard.move(move)
            }
            register(ChessMove(color: color,
                               notation: "",
                               changes: changes,
                               status: chessboard.status(for: color)))

        case .castling(let castling):
            // update the local board
            castling.moves.forEach { chessboard.move($0) }
            // store history
            register(ChessMove(color: color,
                               notation: "",
                               changes: castling.moves.map { .move($0) },
                               status: chessboard.status(for: color)))
        }
    }
    
    private func register(_ move: ChessMove) {
        // store move
        self.moveStack.append(move)
        // send event to sync UI
        moveListener?(move)
    }
    
    public func revert() {
        guard let move = moveStack.last else { return }
        moveStack.removeLast()
        defer {
            chessboard.colorOnMove = chessboard.colorOnMove.other
        }
        let revertedChanges = move.changes.map { $0.reverted }.reversed().map { $0 }
        for change in revertedChanges {
            switch change {
            case .move(let move):
                chessboard.move(move)
            case .remove(_, _, let square):
                chessboard.remove(square)
            case .add(let type, let color, to: let square):
                chessboard.add(type.gamePiece(color: color, square: square))
            }
        }
        let reverseMove = ChessMove(color: move.color,
                                    notation: move.notation,
                                    changes: revertedChanges,
                                    status: move.status)
        moveListener?(reverseMove)
    }
}
