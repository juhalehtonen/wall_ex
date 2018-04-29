// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket";
import canvas from "./canvas";
import input from "./input";

canvas.init();
window.userLineColor = canvas.userLineColor;


/**
 * Attempt to establish a connection to the channel, and display the canvas if
 * successful.
 */
let channel = socket.channel("room:lobby", {});
channel.join()
  .receive("ok", resp => {
      console.log("Joined successfully", resp);
      canvas.displayCanvas();
  })
  .receive("error", resp => {
      console.log("Unable to join", resp);
  });


/**
 * Clear canvas locally when server broadcasts the message to the client.
 * Before clearing, save the canvas locally.
 */
channel.on("clear", payload => {
  let image = canvas.canvasEl.toDataURL("image/png");
  document.getElementById('images').innerHTML += '<a href="'+image+'" target="_blank"><img src="'+image+'"/></a>';
  canvas.clearCanvas();
});

/**
 * Draw lines upon first page load. Can happen multiple times, as the server will
 * batch messages to keep array sizes sane.
 */
channel.on("load", payload => {
    canvas.drawLines(payload.lines);
});

// Draw whatever we receive
channel.on("draw", payload => {
    canvas.drawLines(payload.lines);
});

canvas.clearEl.onclick = function() {
  if (window.confirm("Do you really want to clear the wall for everyone? Everyone can still get a local copy from their browsers.")) {
      channel.push("clear", {});
  }
  return false;
};


/**
 * Calls out canvas.drawLines() for actually drawing the lines, but also pushes
 * the information to the channel to let others know.
 */
window.drawLinesPub = function (lines) {
  canvas.drawLines(lines);

  // If we send our canvasID, the server won't waste bandwidth sending
  // us our own drawLines messages.
  channel.push("draw", {lines: lines, canvas_id: window.canvasID});
}


/**
 * Event listeners
 */


// Touch Handling
function haltEventBefore(handler) {
 return function(event) {
   event.stopPropagation();
   event.preventDefault();
   handler(event);
 };
}

canvas.canvasEl.addEventListener('mousedown', haltEventBefore(function(event) {
  input.mouseDown = true;
  input.moveToCoordinates(canvas.getCanvasCoordinates({"mouse" : event}));
}));

document.documentElement.addEventListener('mouseup', function(event) {
  input.mouseDown = false;
});

canvas.canvasEl.addEventListener('mousemove', haltEventBefore(function(event) {
  if (!input.mouseDown) return;

  input.lineToCoordinates(
    canvas.getCanvasCoordinates({"mouse" : event})
  );
}));

canvas.canvasEl.addEventListener('mouseleave', haltEventBefore(function(event) {
  if (!input.mouseDown) return;

  input.lineToCoordinates(
    canvas.getCanvasCoordinates({"mouse" : event})
  );
}));

canvas.canvasEl.addEventListener('mouseenter', haltEventBefore(function(event) {
  if (!input.mouseDown) return;

  input.moveToCoordinates(
    canvas.getCanvasCoordinates({"mouse" : event})
  );
}));


function handleTouchesWith(func) {
  return haltEventBefore(function(event) {
    var map = {};
    for (var i = 0; i < event.changedTouches.length; i++) {
      var touch = event.changedTouches[i];
      map[touch.identifier] = touch;
    }
    func(canvas.getCanvasCoordinates(map));
  });
};

canvas.canvasEl.addEventListener('touchstart',  handleTouchesWith(input.moveToCoordinates));
canvas.canvasEl.addEventListener('touchmove',   handleTouchesWith(input.lineToCoordinates));
canvas.canvasEl.addEventListener('touchend',    handleTouchesWith(input.lineToCoordinates));
canvas.canvasEl.addEventListener('touchcancel', handleTouchesWith(input.moveToCoordinates));
