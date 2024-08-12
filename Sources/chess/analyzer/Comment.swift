//
//  Comment.swift
//  chess
//
//  Created by Tomasz Kucharski on 12/08/2024.
//

import Foundation
import SQLite

enum ColorOnMove: Int {
    case white
    case black
}

extension ColorOnMove {
    static func from(_ color: ChessPieceColor) -> ColorOnMove {
        switch color {
        case .white:
            return .white
        case .black:
            return .black
        }
    }
}

enum Comment {
    static let name = "comments"
    static let table = Table(Self.name)
    static let positionID = SQLite.Expression<String>("positionID")
    static let parentPositionID = SQLite.Expression<String?>("parentPositionID")
    static let pgnMove = SQLite.Expression<String?>("pgnMove")
    static let colorOnMove = SQLite.Expression<Int>("colorOnMove")
    static let comment = SQLite.Expression<String>("comment")
}

extension Comment {
    static func createTable(db: Connection) throws {
        try db.run(Comment.table.create(ifNotExists: true) { t in
            t.column(Comment.positionID)
            t.column(Comment.parentPositionID)
            t.column(Comment.pgnMove)
            t.column(Comment.colorOnMove)
            t.column(Comment.comment)
        })
        try db.run(Comment.table.createIndex(Comment.positionID, ifNotExists: true))
        try db.run(Comment.table.createIndex(Comment.parentPositionID, ifNotExists: true))
    }
    
    static func getComment(db: Connection, positionID: String) -> String? {
        let query = Comment.table.select([Comment.comment])
            .filter(Comment.positionID == positionID)
            .limit(1)
        if let data = try? db.pluck(query) {
            return data[Comment.comment]
        }
        return nil
    }
    
    
    static func addComment(db: Connection, positionID: String, colorOnMove: ColorOnMove, comment: String) throws {
        try db.run(Comment.table.insert(
            Comment.positionID <- positionID,
            Comment.colorOnMove <- colorOnMove.rawValue,
            Comment.comment <- comment
        ))
    }
}
