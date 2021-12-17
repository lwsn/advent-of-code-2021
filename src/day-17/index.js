const input = "target area: x=281..311, y=-74..-54";

const [_, xmin, xmax, ymin, ymax] =
  /.*=(-?\d+)..(-?\d+).*=(-?\d+)..(-?\d+)/g.exec(input);

const isInTarget = ({ x, y }) =>
  (x === undefined || (x >= xmin && x <= xmax)) &&
  (y === undefined || (y >= ymin && y <= ymax));

const genX = (x) => {};

const validX = Array.from({ length: xmax + 1 }, (_, i) => i);

console.log(xmin, xmax, ymin, ymax);
console.log(validX.slice(-5));
