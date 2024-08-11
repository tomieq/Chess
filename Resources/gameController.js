
let movingPiece;
let pieceStartingSquare;

let mouseX, mouseY = 0;
let movePieceInterval;
let hasIntervalStarted = false;

function loadPosition(positions) {
    for(var square in positions) {
        var piece = positions[square];
        loadPiece(piece, square);
    }
}

function loadPiece(piece, square) {
    const squareElement = document.getElementById(square);
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

function squareFromReleaseCoordinates(x, y) {
    
    if(rotated) {
        const columns = "hgfedcba";
        return columns[x] + (1 + y);
    } else {
        const columns = "abcdefgh";
        return columns[x] + (8 - y);
    }
}

function setPieceHoldEvents() {
    document.addEventListener('mousemove', function(event) {
        mouseX = event.clientX;
        mouseY = event.clientY;
    });

    let pieces = document.getElementsByClassName('piece');

    for (const piece of pieces) {
        registerPieceMove(piece);
    }
        
    document.addEventListener('mouseup', function(event) {
        window.clearInterval(movePieceInterval);

        if (movingPiece != null) {
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

                    const pieceReleaseSquare = squareFromReleaseCoordinates(xPosition, yPosition);

                    if (pieceStartingSquare != pieceReleaseSquare) {
                        tryMove(pieceStartingSquare, pieceReleaseSquare);
                    }
                }

            movingPiece.style.position = 'static';
            movingPiece = null;
            movingPieceStartingPosition = null;
            pieceStartingSquare = null;
        }
    
        hasIntervalStarted = false;
    });
}

function registerPieceMove(piece) {
    piece.addEventListener('mousedown', function(event) {
        mouseX = event.clientX;
        mouseY = event.clientY;
    
        if (hasIntervalStarted === false) {
            piece.style.position = 'absolute';

            movingPiece = piece;
            pieceStartingSquare = piece.parentElement.id;

            movePieceInterval = setInterval(function() {
                piece.style.top = mouseY - piece.offsetHeight / 2 + window.scrollY + 'px';
                piece.style.left = mouseX - piece.offsetWidth / 2 + window.scrollX + 'px';
            }, 1);
    
            hasIntervalStarted = true;
        }
    });
}

function tryMove(fromSquare, toSquare) {
    console.log("Move from " + fromSquare + " to " + toSquare);

    $.getScript( "move?from=" + fromSquare + "&to=" + toSquare )
      .done(function( script, textStatus ) {
      })
      .fail(function( jqxhr, settings, exception ) {
          
    });
}

function removePieceFrom(square) {
    $("#"+square).html("");
}

function addPiece(piece, square) {
    loadPiece(piece, square);
    
    const domPiece = document.getElementById(square).firstChild;
    registerPieceMove(domPiece)
}
