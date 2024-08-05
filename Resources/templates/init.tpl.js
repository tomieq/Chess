function startGame() {
    const starterPosition = {matrix};

    loadPosition(starterPosition);
    setPieceHoldEvents();
}
startGame();

const socket = new WebSocket("ws://{address}/websocket");

// Connection opened
socket.addEventListener("open", (event) => {
  socket.send("Hello Server!");
    console.log("Websocket connected");
});

// Listen for messages
socket.addEventListener("message", (event) => {
    $("#tips").html(event.data)
    console.log("Message from server ", event.data);
});
