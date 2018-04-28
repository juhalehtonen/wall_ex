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

  lineToCoordinates(map, color) {
    var lineColor = color;
    for (var identifier in map) {
      if (!map.hasOwnProperty(identifier))
        continue;

      var point = map[identifier];
      if (input.lastPoints[identifier]) {
        input.lines.push({from:input.lastPoints[identifier], to: point, color: lineColor});
      }
      input.lastPoints[identifier] = point;
    }
  }

}

export default input;
