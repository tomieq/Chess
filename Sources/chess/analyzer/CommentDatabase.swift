//
//  CommentDatabase.swift
//  chess
//
//  Created by Tomasz Kucharski on 12/08/2024.
//
import SQLite
import Template

public class CommentDatabase {
    let db: Connection
    
    public init() {
        self.db = try! Connection(Resource().absolutePath(for: "knowledge.db"))
        try? Comment.createTable(db: db)
    }
    
    public func get(fenPosition: String) -> (String, ChessPieceColor)? {
        guard let (comment, color) = Comment.getComment(db: db, positionID: fenPosition) else {
            return nil
        }
        return (comment, color.color)
    }
    
    public func add(positionID: String, colorOnMove: ChessPieceColor, comment: String) {
        try? Comment.addComment(db: db, positionID: positionID, colorOnMove: ColorOnMove.from(colorOnMove), comment: comment)
    }
}
