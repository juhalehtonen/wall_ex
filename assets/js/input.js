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
    let lines = [];

    for (var identifier in map) {
      if (!map.hasOwnProperty(identifier)) {
        continue;
      }

      var point = map[identifier];

      if (input.lastPoints[identifier]) {
        lines.push({
          from:input.lastPoints[identifier],
          to: point, color: lineColor
        });
      }

      input.lines = lines;
      input.lastPoints[identifier] = point;
    }
  }

}

export default input;
