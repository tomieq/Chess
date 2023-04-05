import XCTest
@testable import chess

final class MoveCalculatorKingTests: XCTestCase {
    func test_kingPossibleMovesFieldsOccupiedByOwnArmy() throws {
        let chessBoard = ChessBoard()
        chessBoard.addPiece(King(.white, "e1"))
        let sut = MoveCalculator(chessBoard: chessBoard)
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 5)
        chessBoard.addPiece(Pawn(.white, "e2"))
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 4)
        chessBoard.addPiece(Pawn(.white, "f2"))
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 3)
        chessBoard.addPiece(Pawn(.white, "d2"))
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 2)
        chessBoard.addPiece(Queen(.white, "d1"))
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 1)
        chessBoard.addPiece(Bishop(.white, "f1"))
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 0)
    }

    func test_kingCannotApproachEnemyKing() {
        let chessBoard = ChessBoard()
        chessBoard.addPiece(King(.white, "d4"))
        let sut = MoveCalculator(chessBoard: chessBoard)
        XCTAssertTrue(sut.possibleMoves(from: "d4")?.passive.contains("d5") ?? false)
        chessBoard.addPiece(King(.black, "d6"))
        XCTAssertFalse(sut.possibleMoves(from: "d4")?.passive.contains("d5") ?? true)
    }

    func test_castlingWhiteKingPossibleMoves() {
        let chessBoard = ChessBoard()
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        let queenSideRook = Rook(.white, "a1")
        chessBoard.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(chessBoard: chessBoard)

        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 7)
        king?.square = "e2"
        XCTAssertEqual(sut.possibleMoves(from: "e2")?.count, 8)
        king?.square = "e1"
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 5)
    }

    func test_castlingWhiteQueenSidePossibleMove() {
        let chessBoard = ChessBoard()
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        let queenSideRook = Rook(.white, "a1")
        chessBoard.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(chessBoard: chessBoard)

        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 7)
        queenSideRook?.square = "a2"
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 6)
        queenSideRook?.square = "a1"
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 6)
    }

    func test_castlingWhiteKingSidePossibleMove() {
        let chessBoard = ChessBoard()
        let king = King(.white, "e1")
        let kingSideRook = Rook(.white, "h1")
        let queenSideRook = Rook(.white, "a1")
        chessBoard.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(chessBoard: chessBoard)

        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 7)
        kingSideRook?.square = "h2"
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 6)
        kingSideRook?.square = "h1"
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 6)
    }

    func test_castlingBlackKingPossibleMoves() {
        let chessBoard = ChessBoard()
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        let queenSideRook = Rook(.black, "a8")
        chessBoard.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(chessBoard: chessBoard)

        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 7)
        king?.square = "e7"
        XCTAssertEqual(sut.possibleMoves(from: "e7")?.count, 8)
        king?.square = "e8"
        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 5)
    }

    func test_castlingBlackQueenSidePossibleMove() {
        let chessBoard = ChessBoard()
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        let queenSideRook = Rook(.black, "a8")
        chessBoard.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(chessBoard: chessBoard)

        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 7)
        queenSideRook?.square = "a7"
        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 6)
        queenSideRook?.square = "a8"
        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 6)
    }

    func test_castlingBlackKingSidePossibleMove() {
        let chessBoard = ChessBoard()
        let king = King(.black, "e8")
        let kingSideRook = Rook(.black, "h8")
        let queenSideRook = Rook(.black, "a8")
        chessBoard.addPieces(king, kingSideRook, queenSideRook)
        XCTAssertEqual(king?.moveCounter, 0)
        let sut = MoveCalculator(chessBoard: chessBoard)

        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 7)
        kingSideRook?.square = "h7"
        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 6)
        kingSideRook?.square = "h8"
        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 6)
    }
}
