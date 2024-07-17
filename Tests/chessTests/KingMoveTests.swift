import XCTest
@testable import chess

final class KingMoveTests: MoveTests {
    func test_kingPossibleMovesFieldsOccupiedByOwnArmy() throws {
        chessBoard.addPiece(King(.white, "e1"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 5)
        chessBoard.addPiece(Pawn(.white, "e2"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 4)
        chessBoard.addPiece(Pawn(.white, "f2"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 3)
        chessBoard.addPiece(Pawn(.white, "d2"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 2)
        chessBoard.addPiece(Queen(.white, "d1"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 1)
        chessBoard.addPiece(Bishop(.white, "f1"))
        XCTAssertEqual(possibleMoves(from: "e1").count, 0)
    }

    func test_kingCannotApproachEnemyKing() {
        chessBoard.addPiece(King(.white, "d4"))
        XCTAssertEqual(possibleMoves(from: "d4").contains("d5"), true)
        chessBoard.addPiece(King(.black, "d6"))
        XCTAssertEqual(possibleMoves(from: "d4").contains("d5"), false)
    }

    func test_kingCannotGoOnSquareControlledByEnemyRook() {
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Ke3")
        ChessBoardLoader(chessBoads: chessBoard).load(.black, "Ke8 Wd8 Wf8")
        XCTAssertEqual(possibleMoves(from: "e3").count, 2)
    }
    
    func test_kingCannotGoOnSquareControlledByEnemyKnights() {
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Ke1")
        ChessBoardLoader(chessBoads: chessBoard).load(.black, "Ke8 Se4 Sf4")
        XCTAssertEqual(possibleMoves(from: "e1").count, 2)
    }

    func test_kingCannotGoOnSquareControlledByEnemyBishop() {
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Ke1")
        ChessBoardLoader(chessBoads: chessBoard).load(.black, "Ke8 Gf4 Gg4")
        XCTAssertEqual(possibleMoves(from: "e1").count, 2)
    }
    
    func test_kingCannotGoOnSquareControlledByEnemyPawns() {
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Ke1")
        ChessBoardLoader(chessBoads: chessBoard).load(.black, "Ke8 e3 f3")
        XCTAssertEqual(possibleMoves(from: "e1").count, 2)
    }
    
    func test_kingCanTakeEnemyPawn() {
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Ke1")
        ChessBoardLoader(chessBoads: chessBoard).load(.black, "e2 Kh8")
        XCTAssertEqual(possibleMoves(from: "e1").count, 3)
        XCTAssertEqual(possibleVictims(for: "e1"), ["e2"])
        XCTAssertEqual(possiblePredators(for: "e1").count, 0)
    }
    
    func test_enemyPawnAttackingKing() {
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Ke1")
        ChessBoardLoader(chessBoads: chessBoard).load(.black, "d2 Kh8")
        XCTAssertEqual(possibleMoves(from: "e1").count, 5)
        XCTAssertEqual(possibleVictims(for: "e1"), ["d2"])
        XCTAssertEqual(possiblePredators(for: "e1"), ["d2"])
    }

    func test_castlingWhiteKingPossibleMoves() {
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        let queenSideRook = Rook(.white, "a1")
        chessBoard.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(possibleMoves(from: "e1").count, 7)
    }
    
    func test_castlingWhiteQueenSidePossibleMove() {
        let king = King(.white, "e1")
        let queenSideRook = Rook(.white, "a1")
        chessBoard.addPieces(king, queenSideRook)
        
        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 6)
        XCTAssertTrue(moves.contains("c1"))
    }

    func test_castlingWhiteKingSidePossibleMove() {
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        chessBoard.addPieces(king, kingSideRook)

        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 6)
        XCTAssertTrue(moves.contains("g1"))
    }
    
    func test_castlingBlackKingPossibleMoves() {
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        let queenSideRook = Rook(.black, "a8")
        chessBoard.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(possibleMoves(from: "e8").count, 7)
    }

    func test_castlingBlackQueenSidePossibleMove() {
        let king = King(.black, "e8")
        let queenSideRook = Rook(.black, "a8")
        chessBoard.addPieces(king, queenSideRook)
        
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 6)
        XCTAssertTrue(moves.contains("c8"))
    }

    func test_castlingBlackKingSidePossibleMove() {
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        chessBoard.addPieces(king, kingSideRook)
        
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 6)
        XCTAssertTrue(moves.contains("g8"))
    }

    func test_movesAtGameStart() {
        chessBoard.setupGame()
        XCTAssertEqual(possibleMoves(from: "e1").count, 0)
        XCTAssertEqual(possibleMoves(from: "e8").count, 0)
    }
    
    func test_whiteQueenSideCastlingBlockedByOwnArmy() {
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Wa1 Sb1 Ke1 Wh1 d2 e2 f2")
        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d1"), true)
        XCTAssertEqual(moves.contains("f1"), true)
        XCTAssertEqual(moves.contains("g1"), true)
    }
    
    func test_whiteKingSideCastlingBlockedByOwnArmy() {
        ChessBoardLoader(chessBoads: chessBoard).load(.white, "Wa1 Sg1 Ke1 Wh1 d2 e2 f2")
        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d1"), true)
        XCTAssertEqual(moves.contains("f1"), true)
        XCTAssertEqual(moves.contains("c1"), true)
    }
    
    func test_blackQueenSideCastlingBlockedByOwnArmy() {
        ChessBoardLoader(chessBoads: chessBoard).load(.black, "Wa8 Sb8 Ke8 Wh8 d7 e7 f7")
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d8"), true)
        XCTAssertEqual(moves.contains("f8"), true)
        XCTAssertEqual(moves.contains("g8"), true)
    }
    
    func test_blackKingSideCastlingBlockedByOwnArmy() {
        ChessBoardLoader(chessBoads: chessBoard).load(.black, "Wa8 Sg8 Ke8 Wh8 d7 e7 f7")
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d8"), true)
        XCTAssertEqual(moves.contains("f8"), true)
        XCTAssertEqual(moves.contains("c8"), true)
    }
    
    func test_whiteQueenCastlingBlockedByEnemy() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Wa1 Ke1 Wh1 Sf3 d2 e2 f2")
            .load(.black, "Wb5")
        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d1"), true)
        XCTAssertEqual(moves.contains("f1"), true)
        XCTAssertEqual(moves.contains("g1"), true)
    }
    
    func test_whiteKingSideCastlingBlockedByEnemy() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Wa1 Sd3 Ke1 Wh1 d2 e2 f2")
            .load(.black, "Wg4")
        let moves = possibleMoves(from: "e1")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d1"), true)
        XCTAssertEqual(moves.contains("f1"), true)
        XCTAssertEqual(moves.contains("c1"), true)
    }
    
    func test_blackQueenSideCastlingBlockedByEnemy() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.black, "Wa8 Sf6 Ke8 Wh8 d7 e7 f7")
            .load(.white, "Wb2")
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d8"), true)
        XCTAssertEqual(moves.contains("f8"), true)
        XCTAssertEqual(moves.contains("g8"), true)
    }
    
    func test_blackKingSideCastlingBlockedByEnemy() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.black, "Wa8 Sc6 Ke8 Wh8 d7 e7 f7")
            .load(.white, "Wg2")
        let moves = possibleMoves(from: "e8")
        XCTAssertEqual(moves.count, 3)
        XCTAssertEqual(moves.contains("d8"), true)
        XCTAssertEqual(moves.contains("f8"), true)
        XCTAssertEqual(moves.contains("c8"), true)
    }

    func test_kingCantTakeSecuredPawn() {
        ChessBoardLoader(chessBoads: chessBoard)
            .load(.white, "Ke1")
            .load(.black, "e2 Ke8 Gb5")
        XCTAssertEqual(possibleMoves(from: "e1").count, 2)
        XCTAssertEqual(possibleVictims(for: "e1"), ["e2"])
        XCTAssertFalse(possibleMoves(from: "e1").contains("e2"))
    }
}

