//
//  GameOpeningDatabase.swift
//  chess
//
//  Created by Tomasz Kucharski on 09/08/2024.
//
import Foundation
import Template

public class GameOpeningDatabase {
    let openings: [GameOpening]
    
    public init() {
        var gamePlays: [GameOpening] = []
        let rootPath = Resource().absolutePath(for: "openings")
        let folders = try? FileManager.default.contentsOfDirectory(atPath: rootPath)
        for folder in folders ?? [] {
            let folderPath = "\(rootPath)/\(folder)/"
            let files = try? FileManager.default.contentsOfDirectory(atPath: folderPath)
            for file in files ?? [] {
                guard let content = try? String(contentsOfFile: folderPath + file, encoding: .utf8) else {
                    continue
                }
                gamePlays.append(GameOpeningLoader.make(from: content, filename: "\(folder)/\(file)"))
            }
        }
        print("Loaded \(gamePlays.count) opening variants")
        openings = gamePlays
    }
    
    public func findMatching(to pgn: String) -> [GameOpening] {
        openings.filter { $0.pgnFlat.starts(with: pgn) }
    }
    
    public func getTips(to pgn: String) -> [String] {
        let key = pgn.md5
        return findMatching(to: pgn).compactMap { gamePlay in
            guard let tip = gamePlay.tips[key] else { return nil }
            return tip + "\n(\(gamePlay.filename))"
        }
    }
}
