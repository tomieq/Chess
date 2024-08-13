//
//  PgnUIView.swift
//  chess
//
//  Created by Tomasz Kucharski on 13/08/2024.
//
import Template
import chess

enum PgnUIView {
    static func html(chessBoard: ChessBoard) -> String {
        let pgnTemplate = Template.cached(relativePath: "templates/pgn.tpl.html")
        var pgnHtml = ""
        var moveCounter = 0
        let moveAmount = chessBoard.movesHistory.count
        chessBoard.pgn
            .chunked(by: 2)
            .enumerated()
            .forEach { (index, pgnPair) in
                pgnTemplate["number"] = index + 1
                for pgn in pgnPair {
                    moveCounter += 1
                    pgnTemplate.assign(["revertAmount": moveAmount - moveCounter, "pgn": pgn], inNest: "move")
                }
                pgnHtml += pgnTemplate.output
                pgnTemplate.reset()
            }
        return pgnHtml
    }
}
