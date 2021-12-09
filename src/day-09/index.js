const input = require("./input.json").map((s) => s.split("").map(Number));

const isLowest = (v, y, x) =>
  [
    input[y][x - 1],
    input[y][x + 1],
    input[y + 1]?.[x],
    input[y - 1]?.[x],
  ].every((n) => n === undefined || v < n);

const resA = input.reduce(
  (a, r, y) =>
    a + r.reduce((b, v, x) => (isLowest(v, y, x) ? b + 1 + v : b), 0),
  0
);

const spans = input
  .map((r) =>
    r.reduce(
      (a, v, i) =>
        (v === 9) === (a.length % 2 === 1) ? [...a, i - (v === 9 ? 1 : 0)] : a,
      []
    )
  )
  .map((v) => (v.length % 2 === 1 ? [...v, input[0].length - 1] : v))
  .map((r) =>
    r
      .reduce(
        ([cur, ...a], v, i) => (i % 2 ? [...a, [cur, v]] : [v, cur, ...a]),
        []
      )
      .filter((v) => v?.length === 2)
  );

const findAdjacent = ([s1, e1], y) => {
  if (!spans[y]) return [];
  const ret = (spans[y] || []).filter(([s2, e2]) => s1 <= e2 && e1 >= s2);
  spans[y] = spans[y].filter((v) => !ret.includes(v));
  return ret.map((span) => ({ span, y }));
};

let basins = [];

const spanSize = ([s, e]) => e - s + 1;

while (spans.some((v) => v?.length)) {
  basins = [0, ...basins];
  const y = spans.findIndex((v) => v.length > 0);

  let basin = [{ span: spans[y].shift(), y }];

  while (basin.length) {
    const span = basin.shift();
    basins[0] += spanSize(span.span);
    basin = [...basin, ...findAdjacent(span.span, span.y - 1)];
    basin = [...basin, ...findAdjacent(span.span, span.y + 1)];
  }
}

console.log(resA);
console.log(
  basins
    .sort((a, b) => b - a)
    .slice(0, 3)
    .reduce((a, v) => a * v, 1)
);
