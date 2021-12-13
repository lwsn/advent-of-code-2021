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
                coords.append(parseCoord(line))
            elif "=" in line:
                folds.append(parseFold(line))

    xmax, ymax = 0, 0
    for c in coords:
        xmax = max(xmax, c[0])
        ymax = max(ymax, c[1])

    board = [[0] * (xmax + 1) for _ in range(ymax + 1)]

    for x, y in coords:
        board[y][x] = 1

    return board,  folds


def maybe(arr, i, d):
    return arr[i] if len(arr) > i else d


def mergeRows(r1, r2):
    return list(map(
        lambda i: (maybe(r1, i, 0) | maybe(r2, i, 0)),
        range(max(len(r1), len(r2)))
    ))


def foldY(board, coord):
    top = board[:coord][::-1]
    bottom = board[coord+1:]

    return list(map(
        lambda i: mergeRows(maybe(top, i, []), maybe(bottom, i, [])),
        range(max(len(top), len(bottom)))
    ))


def foldRow(r, coord):
    left = r[:coord][::-1]
    right = r[coord+1:]

    return list(map(
        lambda i: maybe(left, i, 0) | maybe(right, i, 0),
        range(max(len(right), len(left)))
    ))


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
    for f in folds[:num]:
        board = doFold(board, f)
    return list(map(lambda r: r[::-1], board))[::-1]


def countDots(board):
    return sum(map(lambda r: sum(r), board))


def prettyPrint(board):
    for r in board:
        print(''.join(list(map(lambda v: '█' if v else ' ', r))))


def main():
    board, folds = loadInput()
    print(countDots(doFolds(board, folds, 1)))
    prettyPrint(doFolds(board, folds, 100))


if __name__ == "__main__":
    main()
