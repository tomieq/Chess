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

    func test_kingCannotMoveToOtherKing() {
        let gameState = GameState()
        gameState.addPiece(King(.white, "d4"))
        let sut = MoveValidator(gameState: gameState)
        XCTAssertTrue(sut.canMove(from: "d4", to: "d5"))
        print("PossibleMoves: \(sut.possibleMoves(from: "d4"))")
        gameState.addPiece(King(.black, "d6"))
        print("PossibleMoves: \(sut.possibleMoves(from: "d4"))")
        XCTAssertFalse(sut.canMove(from: "d4", to: "d5"))
    }
}
