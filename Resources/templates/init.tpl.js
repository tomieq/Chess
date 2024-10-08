var rotated = false;

function startGame() {
    const starterPosition = {startingPositionDictionary};

    loadPosition(starterPosition);
    setPieceHoldEvents();
}

var webSocket;
$( document ).ready(function() {
    startGame();
    webSocket = new WebSocket("ws://{address}/websocket");
    
    webSocket.onopen = function (event) {
        console.log("[webSocket] Connection established");
    };
    webSocket.onmessage = function (event) {
        handleMessage(event.data);
    }
    webSocket.onclose = function(event) {
        if (event.wasClean) {
            console.log("[webSocket] [close] Connection closed cleanly, code="+event.code + " reason=" + event.reason);
        } else {
        // e.g. server process killed or network down
        // event.code is usually 1006 in this case
            console.log("[webSocket] [close] Connection closed unexpectedly, code="+event.code + " reason=" + event.reason);
        }
    };

    webSocket.onerror = function(error) {
        console.log("'[webSocket] [error]" + error.message);
    };
    
    $('.square').each(function() {
      $(this).after($('<span class="fieldName">').text($(this).attr("id")));
    });
});


function handleMessage(txt) {
    const parts = txt.split(":");
    switch(parts[0]) {
        case "remove":
            removePieceFrom(parts[1]);
            break;
        case "add":
            addPiece(parts[1], parts[2]);
            break;
        case "pgn":
            $("#pgn").html(txt.slice(4));
            break;
        case "tip":
            $("#tip").html(parts[1]);
            break;
        case "comment":
            $("#comment").val(parts[1]);
        case "debug":
            $("#debug").html(parts[1]);
            break;
        case "fen":
            $("#fen").val(parts[1]);
            break;
        case "error":
            showError(parts[1]);
            break;
        case "checkmate":
            checkMate();
            break;
        case "noMoreMoves":
            $("#nextMove").remove();
            break;
        case "reloadBoard":
            runScripts(["reload.js"]);
            break;
        case "white":
            $("#whitePieces").val(parts[1]);
            break;
        case "black":
            $("#blackPieces").val(parts[1]);
            break;
    }
}

function checkMate() {
    var end = Date.now() + (1 * 1000);

    (function frame() {
        confetti({
            particleCount: 2,
            angle: 60,
            spread: 55,
            origin: { x: 0 }
        });
        confetti({
            particleCount: 3,
            spread: 70,
            origin: { y: 0.6 }
        });
        if (Date.now() < end) {
            requestAnimationFrame(frame);
        }
    }());
}

function send(txt) {
    webSocket.send(txt)
}

function removeAllPieces() {
    $( ".chessRow > div" ).each(function() {
        $(this).html('');
    });
}

function rotateBoard() {
    var board = $('#chessBoard');
    var rows = board.children('div');
    board.html(rows.get().reverse());
    $( ".chessRow" ).each(function() {
        var squares = $(this).children('div');
        $(this).html(squares.get().reverse());
    });
    rotated = !rotated;
    $('.square').each(function() {
      $(this).after($('<span class="fieldName">').text($(this).attr("id")));
    });
}
