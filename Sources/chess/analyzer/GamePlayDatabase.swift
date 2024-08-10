//
//  GamePlayDatabase.swift
//  chess
//
//  Created by Tomasz Kucharski on 09/08/2024.
//
import Foundation
import Template

public class GamePlayDatabase {
    let plays: [GamePlay]
    
    public init() {
        var gamePlays: [GamePlay] = []
        let folderPath = Resource().absolutePath(for: "games")
        let files = try? FileManager.default.contentsOfDirectory(atPath: folderPath)
        for file in files ?? [] {
            guard let content = try? String(contentsOfFile: folderPath + "/" + file, encoding: .utf8) else {
                continue
            }
            gamePlays.append(GamePlayLoader.make(from: content, filename: file))
        }
        print("Loaded \(gamePlays.count) games")
        plays = gamePlays
    }
    
    public func findMatching(to pgn: String) -> [GamePlay] {
        plays.filter { $0.pgnFlat.starts(with: pgn) }
    }
    
    public func getTips(to pgn: String) -> [String] {
        let key = pgn.md5
        return findMatching(to: pgn).compactMap { gamePlay in
            guard let tip = gamePlay.tips[key] else { return nil }
            return tip + " (\(gamePlay.filename))"
        }
    }
}
