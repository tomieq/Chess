import XCTest
@testable import chess

final class MoveCalculatorTests: XCTestCase {
    func test_kingPossibleMovesFieldsOccupiedByOwnArmy() throws {
        let gameState = ChessBoard()
        gameState.addPiece(King(.white, "e1"))
        let sut = MoveCalculator(gameState: gameState)
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 5)
        gameState.addPiece(Pawn(.white, "e2"))
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 4)
        gameState.addPiece(Pawn(.white, "f2"))
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 3)
        gameState.addPiece(Pawn(.white, "d2"))
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 2)
        gameState.addPiece(Queen(.white, "d1"))
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 1)
        gameState.addPiece(Bishop(.white, "f1"))
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 0)
    }

    func test_kingCannotApproachEnemyKing() {
        let gameState = ChessBoard()
        gameState.addPiece(King(.white, "d4"))
        let sut = MoveCalculator(gameState: gameState)
        XCTAssertTrue(sut.possibleMoves(from: "d4")?.passive.contains("d5") ?? false)
        gameState.addPiece(King(.black, "d6"))
        XCTAssertFalse(sut.possibleMoves(from: "d4")?.passive.contains("d5") ?? true)
    }

    func test_castlingWhiteKingPossibleMoves() {
        let gameState = ChessBoard()
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        let queenSideRook = Rook(.white, "a1")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 7)
        king?.square = "e2"
        XCTAssertEqual(sut.possibleMoves(from: "e2")?.count, 8)
        king?.square = "e1"
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 5)
    }

    func test_castlingWhiteQueenSidePossibleMove() {
        let gameState = ChessBoard()
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        let queenSideRook = Rook(.white, "a1")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 7)
        queenSideRook?.square = "a2"
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 6)
        queenSideRook?.square = "a1"
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 6)
    }

    func test_castlingWhiteKingSidePossibleMove() {
        let gameState = ChessBoard()
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        let queenSideRook = Rook(.white, "a1")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 7)
        kingSideRook?.square = "h2"
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 6)
        kingSideRook?.square = "h1"
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 6)
    }

    func test_castlingBlackKingPossibleMoves() {
        let gameState = ChessBoard()
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        let queenSideRook = Rook(.black, "a8")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 7)
        king?.square = "e7"
        XCTAssertEqual(sut.possibleMoves(from: "e7")?.count, 8)
        king?.square = "e8"
        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 5)
    }

    func test_castlingBlackQueenSidePossibleMove() {
        let gameState = ChessBoard()
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        let queenSideRook = Rook(.black, "a8")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 7)
        queenSideRook?.square = "a7"
        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 6)
        queenSideRook?.square = "a8"
        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 6)
    }

    func test_castlingBlackKingSidePossibleMove() {
        let gameState = ChessBoard()
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        let queenSideRook = Rook(.black, "a8")
        gameState.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(gameState: gameState)

        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 7)
        kingSideRook?.square = "h7"
        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 6)
        kingSideRook?.square = "h8"
        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 6)
    }
}
