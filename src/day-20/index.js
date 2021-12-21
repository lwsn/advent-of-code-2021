const [mapping, inputImage] = require("./input.json");

const padImage = (image, fill) => [
  Array.from({ length: image[0].length + 2 }, () => fill),
  ...image.map((row) => [fill, ...row, fill]),
  Array.from({ length: image[0].length + 2 }, () => fill),
];

const getOutput = (image, x, y, fill) =>
  mapping[
    parseInt(
      [
        image[y - 1]?.[x - 1] ?? fill,
        image[y - 1]?.[x] ?? fill,
        image[y - 1]?.[x + 1] ?? fill,
        image[y]?.[x - 1] ?? fill,
        image[y]?.[x] ?? fill,
        image[y]?.[x + 1] ?? fill,
        image[y + 1]?.[x - 1] ?? fill,
        image[y + 1]?.[x] ?? fill,
        image[y + 1]?.[x + 1] ?? fill,
      ]
        .map((v) => (v ? "1" : "0"))
        .join(""),
      2
    )
  ] === "#";

const applyMapping = (image, fill) =>
  image.map((r, y) => r.map((_, x) => getOutput(image, x, y, fill)));

const doit = (image, times) => {
  let output = image.map((r) => r.split("").map((v) => v === "#"));

  for (let i = 0; i < times; i++)
    output = applyMapping(padImage(output, i % 2), i % 2);

  return output.reduce((a, r) => a + r.reduce((b, v) => b + (v ? 1 : 0), 0), 0);
};

console.log(doit(inputImage, 2));
console.log(doit(inputImage, 50));
