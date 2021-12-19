const input = "target area: x=281..311, y=-74..-54";

const [_, xmin, xmax, ymin, ymax] =
  /.*=(-?\d+)..(-?\d+).*=(-?\d+)..(-?\d+)/g.exec(input);

const isInTarget = ({ x, y }) =>
  (x === undefined || (x >= xmin && x <= xmax)) &&
  (y === undefined || (y >= ymin && y <= ymax));

const genX = (x) =>
  Array.from({ length: xmax }, (_, i) => Math.max(0, x - i))
    .reduce(([acc, sum], v) => [[...acc, v + sum], v + sum], [[], 0])[0]
    .filter((v) => v <= xmax);

const genY = (y) =>
  Array.from({ length: Math.abs(ymin) * 2 + 1 }, (_, i) => y - i)
    .reduce(([acc, sum], v) => [[...acc, v + sum], v + sum], [[], 0])[0]
    .filter((v) => v >= ymin);

const xCandidates = Array.from({ length: xmax + 1 }, (_, i) => i)
  .filter((v) => ((v + 1) * v) / 2 >= xmin)
  .map(genX)
  .filter((l) => l.length && l.some((x) => isInTarget({ x })))
  .map((v) => v[0]);

// Values below ymin and above abs(ymin) - 1 will always overshoot the  target
const yCandidates = Array.from(
  { length: Math.abs(ymin) * 2 },
  (_, i) => i - Math.abs(ymin)
)
  .map(genY)
  .filter((l) => l.length && l.some((y) => isInTarget({ y })))
  .map((v) => v[0]);

const candidates = yCandidates.reduce(
  (acc, y) => [...acc, ...xCandidates.reduce((b, x) => [...b, [x, y]], [])],
  []
);

const willHit = ([x, y]) => {
  let curX = 0;
  let curY = 0;

  let velX = x;
  let velY = y;

  while (curX <= xmax && curY >= ymin) {
    curX += velX;
    curY += velY;
    if (isInTarget({ x: curX, y: curY })) return true;

    velX = Math.max(0, velX - 1);
    velY -= 1;
  }
  return false;
};

const validVelocities = candidates.filter(willHit);

const calcMaxY = ([, y]) => (y > 0 ? ((y + 1) * y) / 2 : 0);

const maxYPos = validVelocities
  .map(calcMaxY)
  .reduce((m, v) => (v > m ? v : m), 0);

console.log(maxYPos, validVelocities.length);
