//
//  Array+extension.swift
//  chess
//
//  Created by Tomasz Kucharski on 09/08/2024.
//

extension Array {
    func chunked(by chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
