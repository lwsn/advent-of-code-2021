const input = require("./input.json");

const toFlat = ([x, y]) => x + input.length * y;

const getAdjacent = (i) =>
  [
    [-1, -1],
    [0, -1],
    [1, -1],
    [-1, 0],
    [1, 0],
    [-1, 1],
    [0, 1],
    [1, 1],
  ]
    .map((v) => [
      v[0] + (i % input.length),
      v[1] + Math.floor(i / input.length),
    ])
    .filter(
      ([x, y]) => x >= 0 && y >= 0 && x < input.length && y < input.length
    )
    .map(toFlat);

let ln = input.join("").split("").map(Number);
let count = 0;

const flash = (i, arr) => {
  count++;
  arr[i] = 11;

  getAdjacent(i).forEach((j) => {
    if (arr[j] === 9 || arr[j] === 10) {
      arr = flash(j, arr);
    } else {
      arr[j] = arr[j] + 1;
    }
  });

  return arr;
};

const doStep = (l) =>
  l
    .reduce(
      (acc, _, i) => (acc[i] !== 10 ? acc : flash(i, acc)),
      l.map((v) => v + 1)
    )
    .map((v) => (v >= 10 ? 0 : v));

let step = 0;

for (; step < 100; step++) {
  ln = doStep(ln);
}

const resA = count;

while (ln.some((v) => v !== 0)) {
  ln = doStep(ln);
  step++;
}

const resB = step;

console.log(resA);
console.log(resB);
