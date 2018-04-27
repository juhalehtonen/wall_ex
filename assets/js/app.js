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

/*
import socket from "./socket"

var canvas = document.getElementById("canvas");
var loader = document.getElementById("loader");
var clear = document.getElementById("clear");
var ctx = canvas.getContext("2d");

let Colors = {};
Colors.names = {
    black: "#000000",
    blue: "#0000ff",
    brown: "#a52a2a",
    darkblue: "#00008b",
    darkcyan: "#008b8b",
    darkgrey: "#a9a9a9",
    darkgreen: "#006400",
    darkkhaki: "#bdb76b",
    darkmagenta: "#8b008b",
    darkolivegreen: "#556b2f",
    darkorange: "#ff8c00",
    darkorchid: "#9932cc",
    darkred: "#8b0000",
    darksalmon: "#e9967a",
    darkviolet: "#9400d3",
    fuchsia: "#ff00ff",
    gold: "#ffd700",
    green: "#008000",
    indigo: "#4b0082",
    khaki: "#f0e68c",
    lime: "#00ff00",
    magenta: "#ff00ff",
    maroon: "#800000",
    navy: "#000080",
    olive: "#808000",
    orange: "#ffa500",
    pink: "#ffc0cb",
    purple: "#800080",
    violet: "#800080",
    red: "#ff0000",
};

Colors.random = function() {
    var result;
    var count = 0;
    for (var prop in this.names)
        if (Math.random() < 1/++count)
           result = prop;
    return result;
};

var userLineColor = Colors.random();

function displayCanvas() {
  canvas.classList.add('is-visible');
  loader.classList.add('is-invisible');
}

clear.onclick = function() {
  if (window.confirm("Do you really want to clear the wall for everyone?")) {
      channel.push("clear", {});
  }
  return false;
};



let channel = socket.channel("room:lobby", {});
channel.join()
  .receive("ok", resp => {
      console.log("Joined successfully", resp);
    displayCanvas();
  })
  .receive("error", resp => {
      console.log("Unable to join", resp);
  });


// Clear local canvas when should claear t. server :)
channel.on("clear", payload => {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.beginPath();
});

channel.on("load", payload => {
    _drawLines(payload.lines);
});

function _drawLines(lines) {
  for (var i = 0; i < lines.length; i++) {
    var line = lines[i];

    ctx.beginPath();
    ctx.moveTo(line.from.x, line.from.y);
    ctx.lineTo(line.to.x, line.to.y);
    ctx.strokeStyle = line.color;
    ctx.stroke();
  }
}

function drawLines(lines) {
  _drawLines(lines);

  // If we send our canvasID, the server won't waste bandwidth sending
  // us our own drawLines messages.
  channel.push("draw", {lines: lines, canvas_id: window.canvasID});
}

// Draw whatever we receive
channel.on("draw", payload => {
    _drawLines(payload.lines);
});


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
      lines.push({from:lastPoints[identifier], to: point, color: userLineColor});
    }
    lastPoints[identifier] = point;
  }
  drawLines(lines);
}

function getCanvasCoordinates(map) {
  var rect = canvas.getBoundingClientRect();
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

// Mouse Handling
var mouseDown = false;

canvas.addEventListener('mousedown', haltEventBefore(function(event) {
  mouseDown = true;
  moveToCoordinates(getCanvasCoordinates({"mouse" : event}));
}));

// We need to be able to listen for mouse ups for the entire document
document.documentElement.addEventListener('mouseup', function(event) {
  mouseDown = false;
});

canvas.addEventListener('mousemove', haltEventBefore(function(event) {
  if (!mouseDown) return;
  lineToCoordinates(getCanvasCoordinates({"mouse" : event}));
}));

canvas.addEventListener('mouseleave', haltEventBefore(function(event) {
  if (!mouseDown) return;
  lineToCoordinates(getCanvasCoordinates({"mouse" : event}));
}));

canvas.addEventListener('mouseenter', haltEventBefore(function(event) {
  if (!mouseDown) return;
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

canvas.addEventListener('touchstart',  handleTouchesWith(moveToCoordinates));
canvas.addEventListener('touchmove',   handleTouchesWith(lineToCoordinates));
canvas.addEventListener('touchend',    handleTouchesWith(lineToCoordinates));
canvas.addEventListener('touchcancel', handleTouchesWith(moveToCoordinates));

*/
/**
 * Elm
 */
import Elm from "./elm"
const elmDiv = document.getElementById("elm-main");
Elm.Main.embed(elmDiv);
