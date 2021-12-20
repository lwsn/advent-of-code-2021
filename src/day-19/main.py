import numpy as np


class Scanner:
    def __init__(self, lines, name):
        self.pos = np.array([0, 0, 0])
        self.beacons = []
        self.name = name
        self.rotation = 0
        for line in lines:
            if len(line) == 0:
                continue
            self.beacons.append(np.array(list(map(int, line.split(",")))))

    def absPosBeacons(self):
        for b in self.beacons:
            yield(b + self.pos)

    def mult(self, mtx):
        newBeacons = []
        for b in self.beacons:
            newBeacons.append(np.matmul(mtx, b))
        self.beacons = newBeacons
        self.rotation = (self.rotation + 1) % 24

    def turnCCW(self):
        self.mult(np.array([[0, -1, 0], [1, 0, 0], [0, 0, 1]]))

    def turnCW(self):
        self.mult(np.array([[0, 1, 0], [-1, 0, 0], [0, 0, 1]]))

    def roll(self):
        self.mult(np.array([[1, 0, 0], [0, 0, -1], [0, 1, 0]]))

    def permutations(self, other):
        for b1 in self.beacons:
            for b2 in other.beacons:
                yield (b1, b2)

    def rotations(self):
        for rollIndex in range(6):
            self.roll()
            yield(self)
            for _ in range(3):
                self.turnCW() if rollIndex % 2 == 0 else self.turnCCW()
                yield(self)

    def tryFit(self, other, offset):
        remainingMisses = len(other.beacons) - 12

        for _b2 in other.beacons:
            b2 = _b2 + offset
            foundMatch = False

            if (np.abs(b2) > 1000).any():
                if remainingMisses == 0:
                    return False
                remainingMisses -= 1
                continue

            for b1 in self.beacons:
                if (b1 == b2).all():
                    foundMatch = True
                    break

            if not foundMatch:
                return False
        return True

    def fit(self, other):
        print("Testing", self.name, "against", other.name, end="\r")
        for _ in other.rotations():
            for pair in self.permutations(other):
                offset = pair[0] - pair[1]
                if self.tryFit(other, offset):
                    other.pos = self.pos + offset
                    return True
        return False


class Reality:
    def __init__(self, scanner):
        self.scanners = []
        self.beacons = []
        self.addScanner(scanner)

    def addBeacon(self, beacon):
        for b in self.beacons:
            if (b == beacon).all():
                return
        self.beacons.append(beacon)

    def addScanner(self, scanner):
        self.scanners.append(scanner)
        for b in scanner.absPosBeacons():
            self.addBeacon(b)

    def maxDistance(self):
        maxDistance = 0
        for (i, s1) in enumerate(self.scanners[:-2]):
            for s2 in self.scanners[i:]:
                maxDistance = max(np.sum(np.abs(s1.pos - s2.pos)), maxDistance)
        return maxDistance


def loadInput():
    scanners = []
    with open("./input") as f:
        for sc in f.read().split("\n\n"):
            scanners.append(Scanner(sc.split("\n")[1:], sc.split("\n")[0]))
    return scanners


def main():
    scanners = loadInput()
    lockedScanners = scanners[0:1]
    scanners = scanners[1:]

    reality = Reality(lockedScanners[0])

    while len(lockedScanners) > 0:
        scanner = lockedScanners.pop()
        for s in scanners:
            if scanner.fit(s):
                print(scanner.name, "matched", s.name, "------------")
                lockedScanners.append(s)
                reality.addScanner(s)
        for s in lockedScanners:
            if s in scanners:
                scanners.remove(s)

    print(len(reality.beacons))
    print(reality.maxDistance())


if __name__ == "__main__":
    main()
