const input = {
  mouseDown: false,
  lastPoints: {},
  lines: [],

  moveToCoordinates(map) {
    for (var identifier in map) {
      if (map.hasOwnProperty(identifier)) {
        var point = map[identifier];
        input.lastPoints[identifier] = point;
      }
    }
  },

  lineToCoordinates(map) {
    let lineColor = window.userLineColor;
    var lines = [];

    for (var identifier in map) {
      if (!map.hasOwnProperty(identifier)) {
        continue;
      }

      var point = map[identifier];

      if (input.lastPoints[identifier]) {
        lines.push({
          from: input.lastPoints[identifier],
          to: point,
          color: lineColor
        });
      }

      input.lines = lines;
      input.lastPoints[identifier] = point;
    }

    // TODO: Move outside of global scope
    window.drawLinesPub(input.lines);
  }

}

export default input;
