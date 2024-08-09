//
//  GamePlay.swift
//  chess
//
//  Created by Tomasz Kucharski on 09/08/2024.
//

import Foundation

struct GamePlay {
    let title: String
    let pgn: [String]
    let tips: [Int:String]
}

enum GamePlayLoader {
    static func make(from content: String) -> GamePlay {
        var title = ""
        var pgn: [String] = []
        var tips: [Int:String] = [:]
        let lines = content.split("\n").map { $0.trimmed }.filter { $0.isEmpty.not }
        for line in lines {
            if line.starts(with: "title:") {
                title = line.replacingOccurrences(of: "title:", with: "").trimmed
                continue
            }
            if line.hasPGN {
                let parts = line.split(separator: ".", maxSplits: 1).map { "\($0)" }
                guard let pgnPart = parts.last else { continue }
                let entries = pgnPart.trimmed.split(" ").filter { $0.contains(".").not }
                pgn.append(contentsOf: entries)
                continue
            }
            tips[pgn.count.decremented] = line
        }
        return GamePlay(title: title, pgn: pgn, tips: tips)
    }
}

fileprivate extension String {
    var hasPGN: Bool {
        let pattern = #"^\d+\.\s*"#  // Wyrażenie regularne do sprawdzania numerka z kropką
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}
