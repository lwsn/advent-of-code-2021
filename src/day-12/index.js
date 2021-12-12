const input = require("./input.json");

let formattedInput = input
  .map((v) => v.split("-"))
  .reduce(
    (acc, [v1, v2]) => ({
      ...acc,
      [v1]: [...(acc[v1] || []), v2],
      [v2]: [...(acc[v2] || []), v1],
    }),
    {}
  );

formattedInput = Object.entries(formattedInput).reduce(
  (acc, [k, v]) =>
    k.toUpperCase() === k || k === "end"
      ? acc
      : {
          ...acc,
          [k]: v
            .reduce(
              (bcc, s) =>
                s.toUpperCase() === s
                  ? [...bcc, ...formattedInput[s]]
                  : [...bcc, s],
              []
            )
            .filter((s) => s !== "start")
            .sort(),
        },
  {}
);

const keyMap = Object.keys(formattedInput).filter((v) => v !== "start");
const start = formattedInput.start.map((v) =>
  v === "end" ? -1 : keyMap.indexOf(v)
);

formattedInput = keyMap.reduce(
  (acc, k) => [
    ...acc,
    formattedInput[k].map((v) => (v === "end" ? -1 : keyMap.indexOf(v))),
  ],
  []
);

const traverse = (r, l, fn) =>
  l
    .filter(fn(r))
    .reduce(
      (acc, v) =>
        v === -1 ? acc + 1 : acc + traverse([...r, v], formattedInput[v], fn),
      0
    );

console.log(traverse([], start, (r) => (v) => !r.includes(v)));
console.log(
  traverse(
    [],
    start,
    (r) => (v) =>
      r.filter((v, i) => r.indexOf(v) === i).length === r.length ||
      !r.includes(v)
  )
);
