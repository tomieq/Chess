function startGame() {
    const starterPosition = {matrix};

    loadPosition(starterPosition);
    setPieceHoldEvents();
}
startGame();

const socket = new WebSocket("ws://{address}/websocket");

// Connection opened
socket.addEventListener("open", (event) => {
    console.log("Websocket connected");
});

// Listen for messages
socket.addEventListener("message", (event) => {
    console.log("Message from server ", event.data);
    handleMessage(event.data);
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
    }
}
