import XCTest
@testable import chess

final class MoveValidatorTests: XCTestCase {
    func test_kingPossibleMovesFieldsOccupiedByOwnArmy() throws {
        let gameState = GameState()
        gameState.addPiece(King(.white, "e1"))
        let sut = MoveValidator(gameState: gameState)
        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 5)
        gameState.addPiece(Pawn(.white, "e2"))
        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 4)
        gameState.addPiece(Pawn(.white, "f2"))
        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 3)
        gameState.addPiece(Pawn(.white, "d2"))
        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 2)
        gameState.addPiece(Queen(.white, "d1"))
        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 1)
        gameState.addPiece(Bishop(.white, "f1"))
        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 0)
    }

    func test_kingCannotApproachEnemyKing() {
        let gameState = GameState()
        gameState.addPiece(King(.white, "d4"))
        let sut = MoveValidator(gameState: gameState)
        XCTAssertTrue(sut.canMove(from: "d4", to: "d5"))
        gameState.addPiece(King(.black, "d6"))
        XCTAssertFalse(sut.canMove(from: "d4", to: "d5"))
    }

    func test_castlingWhiteKingPossibleMoves() {
        let gameState = GameState()
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        let queenSideRook = Rook(.white, "a1")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveValidator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 7)
        king?.address = "e2"
        XCTAssertEqual(sut.possibleMoves(from: "e2").count, 8)
        king?.address = "e1"
        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 5)
    }

    func test_castlingWhiteQueenSidePossibleMove() {
        let gameState = GameState()
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        let queenSideRook = Rook(.white, "a1")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveValidator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 7)
        queenSideRook?.address = "a2"
        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 6)
        queenSideRook?.address = "a1"
        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 6)
    }

    func test_castlingWhiteKingSidePossibleMove() {
        let gameState = GameState()
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        let queenSideRook = Rook(.white, "a1")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveValidator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 7)
        kingSideRook?.address = "h2"
        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 6)
        kingSideRook?.address = "h1"
        XCTAssertEqual(sut.possibleMoves(from: "e1").count, 6)
    }

    func test_castlingBlackKingPossibleMoves() {
        let gameState = GameState()
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        let queenSideRook = Rook(.black, "a8")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveValidator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e8").count, 7)
        king?.address = "e7"
        XCTAssertEqual(sut.possibleMoves(from: "e7").count, 8)
        king?.address = "e8"
        XCTAssertEqual(sut.possibleMoves(from: "e8").count, 5)
    }

    func test_castlingBlackQueenSidePossibleMove() {
        let gameState = GameState()
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        let queenSideRook = Rook(.black, "a8")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveValidator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e8").count, 7)
        queenSideRook?.address = "a7"
        XCTAssertEqual(sut.possibleMoves(from: "e8").count, 6)
        queenSideRook?.address = "a8"
        XCTAssertEqual(sut.possibleMoves(from: "e8").count, 6)
    }

    func test_castlingBlackKingSidePossibleMove() {
        let gameState = GameState()
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        let queenSideRook = Rook(.black, "a8")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveValidator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e8").count, 7)
        kingSideRook?.address = "h7"
        XCTAssertEqual(sut.possibleMoves(from: "e8").count, 6)
        kingSideRook?.address = "h8"
        XCTAssertEqual(sut.possibleMoves(from: "e8").count, 6)
    }
}
