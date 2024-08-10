//
//  GamePlay.swift
//  chess
//
//  Created by Tomasz Kucharski on 09/08/2024.
//

import Foundation

public struct GamePlay {
    public let filename: String
    public let title: String
    public let pgn: [String]
    public let pgnFlat: String
    public let tips: [String:String]
}

enum GamePlayLoader {
    static func make(from content: String, filename: String) -> GamePlay {
        var title = ""
        var pgn: [String] = []
        var tips: [String:String] = [:]
        let lines = content.split("\n").map { $0.trimmed }.filter { $0.isEmpty.not }
        for line in lines {
            if line.starts(with: "//") {
                continue
            }
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
            tips[pgn.joined(separator: " ").md5, default: ""].append("\n\(line)")
            tips[pgn.joined(separator: " ").md5] = tips[pgn.joined(separator: " ").md5]?.trimming("\n")
        }
        return GamePlay(filename: filename, title: title, pgn: pgn, pgnFlat: pgn.joined(separator: " "), tips: tips)
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
