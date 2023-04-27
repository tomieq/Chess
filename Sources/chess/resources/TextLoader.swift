//
//  TextLoader.swift
//
//
//  Created by Tomasz on 07/04/2023.
//

import Foundation

enum TextLoader {
    static func load(_ txt: String) -> [String: String] {
        var result: [String: String] = [:]
        txt.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .map { line -> (String, String) in
                var parts = line.components(separatedBy: ":")
                let label = parts.removeFirst().trimmingCharacters(in: .whitespaces)
                return (label, parts.joined(separator: ":").trimmingCharacters(in: .whitespaces))
            }
            .forEach { result[$0.0] = $0.1 }
        return result
    }
}
