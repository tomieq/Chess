//
//  GameOpeningDatabase.swift
//  chess
//
//  Created by Tomasz Kucharski on 09/08/2024.
//
import Foundation
import Template

public class GameOpeningDatabase {
    var openings: [GameOpening] = []
    
    public init(folder: String) {
        loadFromFolder(folder: folder)
        print("Loaded \(openings.count) opening variants")
    }
    
    private func loadFromFolder(folder: String) {
        let files = try? FileManager.default.contentsOfDirectory(atPath: folder)
        print("Loading from \(folder)")
        for file in files ?? [] {
            let path = folder + "/" + file
            if let _ = try? FileManager.default.contentsOfDirectory(atPath: path) {
                loadFromFolder(folder: path)
                continue
            }
            guard let content = try? String(contentsOfFile: path, encoding: .utf8) else {
                continue
            }
            openings.append(GameOpeningLoader.make(from: content, filename: "\(folder)/\(file)"))
        }
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
