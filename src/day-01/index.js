const data = require("./input.json");

const sumInc = (l) => l.slice(1).reduce((a, v, i) => a + (v > l[i] ? 1 : 0), 0);

const outputA = sumInc(data);
const outputB = sumInc(data.slice(2).map((v, i) => v + data[i] + data[i + 1]));

console.log(outputA, outputB);
