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
        XCTAssertEqual(sut.possibleMoves(from: "d4")?.passive.contains("d5"), true)
        chessBoard.addPiece(King(.black, "d6"))
        XCTAssertEqual(sut.possibleMoves(from: "d4")?.passive.contains("d5"), false)
    }

    func test_kingCannotGoOnSquareControlledByEnemy() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Ke3")
        chessBoard.addPieces(.black, "Wd8 Wf8")
        let sut = MoveCalculator(chessBoard: chessBoard)
        XCTAssertEqual(sut.possibleMoves(from: "e3")?.count, 2)
    }

    func test_kingCanTakeEnemyPawn() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Ke1")
        chessBoard.addPieces(.black, "e2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e1")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.agressive, ["e2"])
    }

    func test_kingCannotGoOnSquareControlledByEnemyPawn() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Ke3")
        chessBoard.addPieces(.black, "e4")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e3")
        XCTAssertEqual(moves?.agressive.count, 1)
        XCTAssertEqual(moves?.passive.count, 5)
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

    func test_movesAtGameStart() {
        let chessBoard = ChessBoard()
        chessBoard.setupGame()
        let sut = MoveCalculator(chessBoard: chessBoard)
        XCTAssertEqual(sut.possibleMoves(from: "e1")?.count, 0)
        XCTAssertEqual(sut.possibleMoves(from: "e8")?.count, 0)
    }

    func test_whiteQueenSideCastlingBlockedByOwnArmy() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Wa1 Sb1 Ke1 Wh1 d2 e2 f2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e1")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.passive.contains("d1"), true)
        XCTAssertEqual(moves?.passive.contains("f1"), true)
        XCTAssertEqual(moves?.passive.contains("g1"), true)
    }

    func test_whiteKingSideCastlingBlockedByOwnArmy() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Wa1 Sg1 Ke1 Wh1 d2 e2 f2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e1")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.passive.contains("d1"), true)
        XCTAssertEqual(moves?.passive.contains("f1"), true)
        XCTAssertEqual(moves?.passive.contains("c1"), true)
    }

    func test_blackQueenSideCastlingBlockedByOwnArmy() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.black, "Wa8 Sb8 Ke8 Wh8 d7 e7 f7")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e8")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.passive.contains("d8"), true)
        XCTAssertEqual(moves?.passive.contains("f8"), true)
        XCTAssertEqual(moves?.passive.contains("g8"), true)
    }

    func test_blackKingSideCastlingBlockedByOwnArmy() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.black, "Wa8 Sg8 Ke8 Wh8 d7 e7 f7")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e8")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.passive.contains("d8"), true)
        XCTAssertEqual(moves?.passive.contains("f8"), true)
        XCTAssertEqual(moves?.passive.contains("c8"), true)
    }

    func test_whiteQueenCastlingBlockedByEnemy() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Wa1 Ke1 Wh1 Sf3 d2 e2 f2")
        chessBoard.addPieces(.black, "Wb5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e1")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.passive.contains("d1"), true)
        XCTAssertEqual(moves?.passive.contains("f1"), true)
        XCTAssertEqual(moves?.passive.contains("g1"), true)
    }

    func test_whiteKingSideCastlingBlockedByEnemy() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Wa1 Sd3 Ke1 Wh1 d2 e2 f2")
        chessBoard.addPieces(.black, "Wg4")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e1")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.passive.contains("d1"), true)
        XCTAssertEqual(moves?.passive.contains("f1"), true)
        XCTAssertEqual(moves?.passive.contains("c1"), true)
    }

    func test_blackQueenSideCastlingBlockedByEnemy() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.black, "Wa8 Sf6 Ke8 Wh8 d7 e7 f7")
        chessBoard.addPieces(.white, "Wb2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e8")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.passive.contains("d8"), true)
        XCTAssertEqual(moves?.passive.contains("f8"), true)
        XCTAssertEqual(moves?.passive.contains("g8"), true)
    }

    func test_blackKingSideCastlingBlockedByEnemy() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.black, "Wa8 Sc6 Ke8 Wh8 d7 e7 f7")
        chessBoard.addPieces(.white, "Wg2")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e8")
        XCTAssertEqual(moves?.count, 3)
        XCTAssertEqual(moves?.passive.contains("d8"), true)
        XCTAssertEqual(moves?.passive.contains("f8"), true)
        XCTAssertEqual(moves?.passive.contains("c8"), true)
    }

    func test_kingCantTakeSecuredPawn() {
        let chessBoard = ChessBoard()
        chessBoard.addPieces(.white, "Ke1")
        chessBoard.addPieces(.black, "e2 Ke8 Gb5")
        let sut = MoveCalculator(chessBoard: chessBoard)
        let moves = sut.possibleMoves(from: "e1")
        XCTAssertEqual(moves?.count, 2)
        XCTAssertEqual(moves?.agressive, [])
    }
}
