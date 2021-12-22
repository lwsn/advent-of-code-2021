import numpy as np
import math


class Cuboid:
    def __init__(self, min, max, off=False):
        self.min = min
        self.max = max
        self.off = off

    def __add__(self, other):
        return self.volume() + other

    __radd__ = __add__

    def volume(self):
        return np.product(self.max - self.min + 1)

    def fullyContained(self, other):
        return (self.min <= other.min).all() and (self.max >= other.max).all()

    def slice(self, axis, coord):
        if self.min[axis] > coord or self.max[axis] < coord:
            return [self]

        aMin, bMax = self.min, self.max
        aMax, bMin = self.max.copy(), self.min.copy()
        np.put(aMax, axis, math.floor(coord))
        np.put(bMin, axis, math.ceil(coord))
        return [Cuboid(aMin, aMax), Cuboid(bMin, bMax)]

    def intersect(self, other):
        slices = [other]

        if (other.max < self.min).any() or (other.min > self.max).any():
            return slices

        for axis in [0, 1, 2]:
            for coord in [self.min[axis] - 0.5, self.max[axis] + 0.5]:
                newSlices = []
                for c in slices:
                    newSlices += c.slice(axis, coord)
                slices = []
                for c in newSlices:
                    if not self.fullyContained(c):
                        slices.append(c)
        return slices


def parseLine(str):
    min = []
    max = []
    op, str = str.split(" ")

    for a in str.split(","):
        a = a.split("=")[1]
        a, b = sorted(map(int, a.split("..")))
        min.append(a)
        max.append(b)

    return Cuboid(np.array(min),  np.array(max), op == "off")


def loadInput():
    cuboids = []
    with open("./input") as f:
        for line in f.readlines():
            cuboids.append(parseLine(line))
    return cuboids


def main():
    cuboids = loadInput()

    newCuboids = []
    for c in cuboids:
        nextCuboids = []
        for e in newCuboids:
            for s in c.intersect(e):
                nextCuboids.append(s)
        newCuboids = nextCuboids
        if not c.off:
            newCuboids.append(c)

    print(sum(newCuboids))


if __name__ == "__main__":
    main()
