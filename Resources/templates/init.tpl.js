function startGame() {
    const starterPosition = {matrix};

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
        case "text":
            $("#tips").append("<br>" + parts[1]);
            break;
        case "checkmate":
            checkMate();
        case "noMoreMoves":
            $("#nextMove").remove();
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
