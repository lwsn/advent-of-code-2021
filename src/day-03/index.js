const input = require("./input.json");

const byCol = input[0]
  .split("")
  .reduce((a, _, i) => [...a, input.map((v) => Number(v[i]))], []);

const gamma = byCol.reduce(
  (a, c) => [...a, Number(c.filter(Boolean).length > c.length / 2)],
  []
);

const epsilon = gamma.map((v) => Number(!v));

const resA = parseInt(gamma.join(""), 2) * parseInt(epsilon.join(""), 2);

const byPos = (l, i) =>
  l.reduce((a, v) => a[Number(v[i])].push(v) && a, [[], []]);

const most = ([z, o]) => (z.length > o.length ? z : o);

const oxygen = input[0].split("").reduce((a, _, i) => most(byPos(a, i)), input);

const least = ([z, o]) =>
  (z.length > o.length && o.length) || !z.length ? o : z;

const scrub = input[0].split("").reduce((a, _, i) => least(byPos(a, i)), input);

const resB = parseInt(oxygen[0], 2) * parseInt(scrub[0], 2);

console.log(resA, resB);
