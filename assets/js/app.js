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
let channel = socket.channel("room:lobby", {})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })


var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

function drawLine(from, to) {
  // Send a message to draw a line to server
  channel.push("draw", {line: [from, to]})
}

channel.on("draw", payload => {
  var from = payload.line[0];
  var to = payload.line[1];

  console.log(payload);

  ctx.moveTo(from.x, from.y);
  ctx.lineTo(to.x, to.y);
  ctx.stroke();
})

// ------------------------
//  General Input Tracking
// ------------------------

var lastPoints = {};

function moveTo(identifier, point) {
  lastPoints[identifier] = point;
}

function lineTo(identifier, point) {
  if (lastPoints[identifier]) {
    drawLine(lastPoints[identifier], point);
  }
  lastPoints[identifier] = point;
}

function getPos(client) {
  var rect = canvas.getBoundingClientRect();
  return {
    x: client.clientX - rect.left,
    y: client.clientY - rect.top
  };
}

function haltEventBefore(handler) {
  return function(event) {
    event.stopPropagation();
    event.preventDefault();
    handler(event);
  }
}

// ----------------
//  Touch Handling
// ----------------

var mouseDown = false;

canvas.addEventListener('mousedown', haltEventBefore(function(event) {
  mouseDown = true;
  moveTo("mouse", getPos(event));
}));

// We need to be able to listen for mouse ups for the entire document
document.documentElement.addEventListener('mouseup', function(event) {
  mouseDown = false;
});

canvas.addEventListener('mousemove', haltEventBefore(function(event) {
  if (!mouseDown) return;
  lineTo("mouse", getPos(event));
}));

canvas.addEventListener('mouseleave', haltEventBefore(function(event) {
  if (!mouseDown) return;
  lineTo("mouse", getPos(event));
}));

canvas.addEventListener('mouseenter', haltEventBefore(function(event) {
  if (!mouseDown) return;
  moveTo("mouse", getPos(event));
}));

// ----------------
//  Touch Handling
// ----------------

function handleTouchesWith(func) {
  return haltEventBefore(function(event) {
    for (var i = 0; i < event.changedTouches.length; i++) {
      var touch = event.changedTouches[i];
      func(touch.identifier, getPos(touch));
    }
  });
};

canvas.addEventListener('touchstart',  handleTouchesWith(moveTo));
canvas.addEventListener('touchmove',   handleTouchesWith(lineTo));
canvas.addEventListener('touchend',    handleTouchesWith(lineTo));
canvas.addEventListener('touchcancel', handleTouchesWith(moveTo));
