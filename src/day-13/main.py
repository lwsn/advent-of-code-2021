def parseFold(s):
    axis, coord = s.replace("fold along ", "").split("=")
    coord = int(coord)
    return (axis, coord)


def parseCoord(s):
    x, y = map(int, s.split(","))
    return (x, y)


def loadInput():
    coords, folds = [], []
    with open("./input") as f:
        for line in f:
            if "," in line:
                coords.append(line)
            elif "=" in line:
                folds.append(line)

    folds = list(map(parseFold, folds))
    coords = list(map(parseCoord, coords))

    xmax, ymax = 0, 0

    for c in coords:
        if c[0] > xmax:
            xmax = c[0]
        if c[1] > ymax:
            ymax = c[1]

    board = [[0] * (xmax + 1) for _ in range(ymax + 1)]

    for c in coords:
        board[c[1]][c[0]] = 1

    return board,  folds


def maybe(arr, i, d):
    return arr[i] if len(arr) > i else d


def mergeRows(r1, r2):
    newrow = range(max(len(r1), len(r2)))
    return list(map(
        lambda i: maybe(r1, i, 0) | maybe(r2, i, 0),
        newrow
    ))


def foldY(board, coord):
    top = board[:coord][::-1]
    bottom = board[coord+1:]

    newlength = max(len(top), len(bottom))

    return list(map(
        lambda i: mergeRows(maybe(top, i, []), maybe(bottom, i, [])),
        range(newlength)
    ))[::-1]


def foldRow(r, coord):
    left = r[:coord][::-1]
    right = r[coord+1:]

    newlength = max(len(right), len(left))

    return list(map(
        lambda i: maybe(left, i, 0) | maybe(right, i, 0),
        range(newlength)
    ))[::-1]


def foldX(board, coord):
    return list(map(
        lambda r: foldRow(r, coord),
        board
    ))


def doFold(board, fold):
    axis, coord = fold
    if axis == "y":
        return foldY(board, coord)
    return foldX(board, coord)


def doFolds(board, folds, num):
    newBoard = board
    for f in folds[:num]:
        newBoard = doFold(newBoard, f)
    return newBoard


def countDots(board):
    sum = 0
    for r in board:
        for v in r:
            sum += v
    return sum


def prettyPrint(board):
    for r in board:
        print(''.join(list(map(lambda v: '█' if v else ' ', r))))


def main():
    board, folds = loadInput()
    print(countDots(doFolds(board, folds, 1)))
    prettyPrint(doFolds(board, folds, 100))


if __name__ == "__main__":
    main()
