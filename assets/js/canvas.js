// This file contains the basic operations on the canvas element.
const canvas = {

  init() {
    this.captureEls();
    this.setContext();
    this.setUserLineColor();
    this.showUserLineColor();
  },

  canvasEl: '',
  loaderEl: '',
  clearEl: '',
  colorEl: '',
  ctx: '',
  userLineColor: '',

  captureEls() {
      this.canvasEl = document.getElementById("canvas");
      this.loaderEl = document.getElementById("loader");
      this.clearEl = document.getElementById("clear");
      this.colorEl = document.getElementById("color");
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

  showUserLineColor() {
    this.colorEl.style.backgroundColor = this.userLineColor;
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
    prestigeBlue: "#2f3542",
    watermelon: "#ff4757",
    saturatedSky: "#5352ed",
    clearChill: "#1e90ff",
    pureApple: "#6ab04c",
    nycTaxi: "#f7b731",
    turquoiseTopaz: "#0fb9b1",
    magentaPurple: "#6F1E51",
    bayWharf: "#747d8c"
  },

  getRandomColor() {
      var result;
      var count = 0;
      for (var prop in canvas.colors)
          if (Math.random() < 1/++count)
             result = canvas.colors[prop];
      return result;
  }
}

export default canvas
