//
//  Text.swift
//
//
//  Created by Tomasz on 07/04/2023.
//

import Foundation

enum Text {
    private static let values: [String: String] = TextLoader.load(Polish.content)
    static subscript(_ label: String) -> String {
        get {
            return Self.values[label] ?? "unknown:\(label)"
        }
    }
}
