const input = require("./input.json").map((v) => [
  v.split(" ")[0],
  Number(v.split(" ")[1]),
]);

const resA = input.reduce(
  (a, [dir, v]) =>
    dir === "forward"
      ? [a[0] + v, a[1]]
      : [a[0], a[1] + v * (dir === "up" ? -1 : 1)],
  [0, 0]
);

const resB = input.reduce(
  (a, [dir, v]) =>
    dir === "forward"
      ? [a[0] + v, a[1] + v * a[2], a[2]]
      : [a[0], a[1], a[2] + v * (dir === "up" ? -1 : 1)],
  [0, 0, 0]
);

console.log(resA[0] * resA[1], resB[0] * resB[1]);
