let curBoard;

let curHeldPiece;
let curHeldPieceStartingPosition;

function startGame() {
    const starterPosition = [['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'],
    ['P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'],
    ['.', '.', '.', '.', '.', '.', '.', '.'],
    ['.', '.', '.', '.', '.', '.', '.', '.'],
    ['.', '.', '.', '.', '.', '.', '.', '.'],
    ['.', '.', '.', '.', '.', '.', '.', '.'],
    ['p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'],
    ['r', 'n', 'b', 'q', 'k', 'b', 'n', 'r']];

    loadPosition(starterPosition);
}

function loadPosition(position) {
    curBoard = position;

    for (let i = 0; i < 8; i++) {
        for (let j = 0; j < 8; j++) {
            if (position[i][j] != '.') {
                loadPiece(position[i][j], [i + 1, j + 1]);
            }
        }
    }
}

function loadPiece(piece, position) {
    const squareElement = document.getElementById(`${position[0]}${position[1]}`);

    const pieceElement = document.createElement('img');
    pieceElement.classList.add('piece');
    pieceElement.id = piece;
    pieceElement.draggable = false;
    pieceElement.src = getPieceImageSource(piece);

    squareElement.appendChild(pieceElement);
}

function getPieceImageSource(piece) {
    switch (piece) {
        case 'R': return 'assets/black_rook.png';
        case 'N': return 'assets/black_knight.png';
        case 'B': return 'assets/black_bishop.png';
        case 'Q': return 'assets/black_queen.png';
        case 'K': return 'assets/black_king.png';
        case 'P': return 'assets/black_pawn.png';
        case 'r': return 'assets/white_rook.png';
        case 'n': return 'assets/white_knight.png';
        case 'b': return 'assets/white_bishop.png';
        case 'q': return 'assets/white_queen.png';
        case 'k': return 'assets/white_king.png';
        case 'p': return 'assets/white_pawn.png';
    }
}

function setPieceHoldEvents() {
    let mouseX, mouseY = 0;

    document.addEventListener('mousemove', function(event) {
        mouseX = event.clientX;
        mouseY = event.clientY;
    });

    let pieces = document.getElementsByClassName('piece');
    let movePieceInterval;
    let hasIntervalStarted = false;

    for (const piece of pieces) {
        piece.addEventListener('mousedown', function(event) {
            mouseX = event.clientX;
            mouseY = event.clientY;
        
            if (hasIntervalStarted === false) {
                piece.style.position = 'absolute';

                curHeldPiece = piece;
                const curHeldPieceStringPosition = piece.parentElement.id.split('');

                curHeldPieceStartingPosition = [parseInt(curHeldPieceStringPosition[0]) - 1, parseInt(curHeldPieceStringPosition[1]) - 1];

                movePieceInterval = setInterval(function() {
                    piece.style.top = mouseY - piece.offsetHeight / 2 + window.scrollY + 'px';
                    piece.style.left = mouseX - piece.offsetWidth / 2 + window.scrollX + 'px';
                }, 1);
        
                hasIntervalStarted = true;
            }
        });
    }
        
    document.addEventListener('mouseup', function(event) {
        window.clearInterval(movePieceInterval);

        if (curHeldPiece != null) {
            const boardElement = document.querySelector('.board');

            if ((event.clientX > boardElement.offsetLeft - window.scrollX && event.clientX < boardElement.offsetLeft + boardElement.offsetWidth - window.scrollX) &&
                (event.clientY > boardElement.offsetTop - window.scrollY && event.clientY < boardElement.offsetTop + boardElement.offsetHeight - window.scrollY)) {
                    const mousePositionOnBoardX = event.clientX - boardElement.offsetLeft + window.scrollX;
                    const mousePositionOnBoardY = event.clientY - boardElement.offsetTop + window.scrollY;

                    const boardBorderSize = parseInt(getComputedStyle(document.querySelector('.board'), null)
                                                .getPropertyValue('border-left-width')
                                                .split('px')[0]);

                    const xPosition = Math.floor((mousePositionOnBoardX - boardBorderSize) / document.getElementsByClassName('square')[0].offsetWidth);
                    const yPosition = Math.floor((mousePositionOnBoardY - boardBorderSize) / document.getElementsByClassName('square')[0].offsetHeight);

                    const pieceReleasePosition = [yPosition, xPosition];

                    if (!(pieceReleasePosition[0] == curHeldPieceStartingPosition[0] && pieceReleasePosition[1] == curHeldPieceStartingPosition[1])) {
                        tryMove(curHeldPiece, curHeldPieceStartingPosition, pieceReleasePosition);
                    }
                }

            curHeldPiece.style.position = 'static';
            curHeldPiece = null;
            curHeldPieceStartingPosition = null;
        }
    
        hasIntervalStarted = false;
    });
}

function movePiece(piece, startingPosition, endingPosition) {
    // move validations to validateMovement()
    const boardPiece = curBoard[startingPosition[0]][startingPosition[1]];
    
    if (boardPiece != '.') {
        curBoard[startingPosition[0]][startingPosition[1]] = '.';
        curBoard[endingPosition[0]][endingPosition[1]] = boardPiece;

        const destinationSquare = document.getElementById(`${endingPosition[0] + 1}${endingPosition[1] + 1}`);
        destinationSquare.textContent = '';
        destinationSquare.appendChild(piece);
    }
}

function tryMove(piece, startingPosition, endingPosition) {
    const boardPiece = curBoard[startingPosition[0]][startingPosition[1]];
    console.log("Move from " + unifiedSquareName(startingPosition)+ " to " +unifiedSquareName(endingPosition));

    $.getScript( "move?from=" + unifiedSquareName(startingPosition) + "&to=" + unifiedSquareName(endingPosition) )
      .done(function( script, textStatus ) {
          movePiece(piece, startingPosition, endingPosition);
      })
      .fail(function( jqxhr, settings, exception ) {
          
    });
}

function unifiedSquareName(position) {
    let files = "abcdefgh";
    return files[position[1]] + "" + (8 - [position[0]]);
}
