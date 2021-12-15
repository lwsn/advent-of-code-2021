const input = require("./input.json").map((s) => s.split("").map(Number));

const part1 = (list) => {
  const grid = new Array(list.length)
    .fill()
    .map(() => new Array(list[0].length).fill(Infinity));

  let queue = [
    {
      x: list[0].length - 1,
      y: list.length - 1,
      cost: list[list.length - 1][list[0].length - 1],
    },
  ];

  while (queue.length) {
    const { x, y, cost } = queue.pop();
    if (cost < grid[y][x]) {
      grid[y][x] = cost;
      queue = [
        ...queue,
        ...[
          [x - 1, y],
          [x, y - 1],
          [x + 1, y],
          [x, y + 1],
        ]
          .filter(([x2, y2]) => list[y2]?.[x2])
          .filter(([x2, y2]) => cost + list[y2][x2] < grid[y2][x2])
          .map(([x2, y2]) => ({ x: x2, y: y2, cost: cost + list[y2][x2] })),
      ].sort((a, b) => b.cost - a.cost);
    }
  }

  return Math.min(grid[0][1], grid[1][0]);
};

const part2 = (list) => {
  const five = new Array(5).fill(0).map((_, i) => i);
  const newlist = five
    .reduce(
      (l, v) => [...l, ...list.map((r) => r.map((c) => ((c + v - 1) % 9) + 1))],
      []
    )
    .map((r) =>
      five.reduce((l, v) => [...l, ...r.map((c) => ((c + v - 1) % 9) + 1)], [])
    );

  return part1(newlist);
};

console.log(part1(input));
console.log(part2(input));
