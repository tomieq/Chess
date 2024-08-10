//
//  GamePlayLoaderTests.swift
//  chess
//
//  Created by Tomasz KUCHARSKI on 09/08/2024.
//

import XCTest
@testable import chess

class GamePlayLoaderTests: XCTestCase {
    func test_load() {
        let content = """
        title: Smażona wątróbka z pułapką czarnych
        // komentarz
        1. e4 e5
        2. Nf3 Nc6
        3. Bc4 Nf6
        4. Ng5 d5
        5. exd5
        
        Zamiast odbijać skoczkiem z f (Nxd5) idziemy skoczkiem z c!
        
        5. ... Nd4
        6. d6
        Biały przepycha piona
        Druga linia
        6. ... Qxd6
        
        To jest podpucha, bo nadal grożą widły na wieżę i hetmana
        """
        let gamePlay = GamePlayLoader.make(from: content, filename: "test")
        XCTAssertEqual(gamePlay.title, "Smażona wątróbka z pułapką czarnych")
        XCTAssertEqual(gamePlay.pgn, "e4 e5 Nf3 Nc6 Bc4 Nf6 Ng5 d5 exd5 Nd4 d6 Qxd6".split(" "))
        XCTAssertEqual(gamePlay.tips["e4 e5 Nf3 Nc6 Bc4 Nf6 Ng5 d5 exd5".md5], "Zamiast odbijać skoczkiem z f (Nxd5) idziemy skoczkiem z c!")
        XCTAssertEqual(gamePlay.tips["e4 e5 Nf3 Nc6 Bc4 Nf6 Ng5 d5 exd5 Nd4 d6".md5], "Biały przepycha piona\nDruga linia")
        XCTAssertEqual(gamePlay.tips["e4 e5 Nf3 Nc6 Bc4 Nf6 Ng5 d5 exd5 Nd4 d6 Qxd6".md5], "To jest podpucha, bo nadal grożą widły na wieżę i hetmana")
    }
}
