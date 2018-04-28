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
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"
import canvas from "./canvas"
import pointer from "./pointer"
canvas.init();

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
 */
channel.on("clear", payload => {
  canvas.clearCanvas();
});

/**
 * Draw lines upon first page load. Can happen multiple times, as the server will
 * batch messages to keep array sizes sane.
 */
channel.on("load", payload => {
    drawLines(payload.lines);
});

// Draw whatever we receive
channel.on("draw", payload => {
    drawLines(payload.lines);
});


canvas.clearEl.onclick = function() {
  if (window.confirm("Do you really want to clear the wall for everyone?")) {
      channel.push("clear", {});
  }
  return false;
};

/**
 * Draw out given lines on the canvas. Simply handles the painting and does not
 * care about what happens on the channel.
 TODO: drop this and just use canvas.drawlines directly.
 */
function drawLines(lines) {
  canvas.drawLines(lines);
}

/**
 * Calls out drawLines() for actually drawing the lines, but also pushes that
 * information to the channel to let others know.
 */
function drawLinesPub(lines) {
  drawLines(lines);

  // If we send our canvasID, the server won't waste bandwidth sending
  // us our own drawLines messages.
  channel.push("draw", {lines: lines, canvas_id: window.canvasID});
}



//  General Input Tracking
var lastPoints = {};

function moveToCoordinates(map) {
  for (var identifier in map) {
    if (map.hasOwnProperty(identifier)) {
      var point = map[identifier];
      lastPoints[identifier] = point;
    }
  }
}

function lineToCoordinates(map) {
  var lines = [];
  for (var identifier in map) {
    if (!map.hasOwnProperty(identifier))
      continue;

    var point = map[identifier];
    if (lastPoints[identifier]) {
      lines.push({from:lastPoints[identifier], to: point, color: canvas.userLineColor});
    }
    lastPoints[identifier] = point;
  }
  drawLinesPub(lines);
}

function getCanvasCoordinates(map) {
  var rect = canvas.canvasEl.getBoundingClientRect();
  var returnValue = {};

  for (var identifier in map) {
    if (!map.hasOwnProperty(identifier))
      continue;

    var client = map[identifier];
    returnValue[identifier] = {
      x: client.clientX - rect.left,
      y: client.clientY - rect.top
    };
  }
  return returnValue;
}

function haltEventBefore(handler) {
  return function(event) {
    event.stopPropagation();
    event.preventDefault();
    handler(event);
  };
}


canvas.canvasEl.addEventListener('mousedown', haltEventBefore(function(event) {
  pointer.mouseDown = true;
  moveToCoordinates(getCanvasCoordinates({"mouse" : event}));
}));

// We need to be able to listen for mouse ups for the entire document
document.documentElement.addEventListener('mouseup', function(event) {
  pointer.mouseDown = false;
});

canvas.canvasEl.addEventListener('mousemove', haltEventBefore(function(event) {
  if (!pointer.mouseDown) return;
  lineToCoordinates(getCanvasCoordinates({"mouse" : event}));
}));

canvas.canvasEl.addEventListener('mouseleave', haltEventBefore(function(event) {
  if (!pointer.mouseDown) return;
  lineToCoordinates(getCanvasCoordinates({"mouse" : event}));
}));

canvas.canvasEl.addEventListener('mouseenter', haltEventBefore(function(event) {
  if (!pointer.mouseDown) return;
  moveToCoordinates(getCanvasCoordinates({"mouse" : event}));
}));

// Touch Handling
function handleTouchesWith(func) {
  return haltEventBefore(function(event) {
    var map = {};
    for (var i = 0; i < event.changedTouches.length; i++) {
      var touch = event.changedTouches[i];
      map[touch.identifier] = touch;
    }
    func(getCanvasCoordinates(map));
  });
};

canvas.canvasEl.addEventListener('touchstart',  handleTouchesWith(moveToCoordinates));
canvas.canvasEl.addEventListener('touchmove',   handleTouchesWith(lineToCoordinates));
canvas.canvasEl.addEventListener('touchend',    handleTouchesWith(lineToCoordinates));
canvas.canvasEl.addEventListener('touchcancel', handleTouchesWith(moveToCoordinates));
