// This file contains the basic operations on the canvas element.
const canvas = {

  init() {
    this.captureEls();
    this.setContext();
    this.setUserLineColor();
  },

  canvasEl: '',
  loaderEl: '',
  clearEl: '',
  ctx: '',
  userLineColor: '',

  captureEls() {
      this.canvasEl = document.getElementById("canvas");
      this.loaderEl = document.getElementById("loader");
      this.clearEl = document.getElementById("clear");
  },

  setContext() {
    this.ctx = canvas.canvasEl.getContext("2d");
  },

  displayCanvas() {
    this.canvasEl.classList.add('is-visible');
    this.loaderEl.classList.add('is-invisible');
  },

  setUserLineColor() {
    this.userLineColor = this.getRandomColor();
  },

  clearCanvas() {
    this.ctx.clearRect(0, 0, this.canvasEl.width, this.canvasEl.height);
    this.ctx.beginPath();
  },

  drawLines(lines) {
    for (var i = 0; i < lines.length; i++) {
      var line = lines[i];

      this.ctx.beginPath();
      this.ctx.moveTo(line.from.x, line.from.y);
      this.ctx.lineTo(line.to.x, line.to.y);
      this.ctx.strokeStyle = line.color;
      this.ctx.stroke();
    }
  },

  getCanvasCoordinates(map) {
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
  },

  // Store available colors
  colors: {
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
  },

  getRandomColor() {
      var result;
      var count = 0;
      for (var prop in canvas.colors)
          if (Math.random() < 1/++count)
             result = prop;
      return result;
  }
}

export default canvas
