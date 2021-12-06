boards = []
draw = []

with open("./input") as f:
    draw = list(map(int, f.readline().split(",")))
    for line in f:
        if len(line) <= 1:
            boards.append([])
        else:
            boards[-1].extend(list(map(int, line.strip().replace("  ", " ").split(" "))))


def isWinner(board):
    for y in range(5):
        sumR = 0
        sumC = 0
        for x in range(5):
            sumR += board[x + y*5]
            sumC += board[y + x*5]
        if sumR == -5 or sumC == -5:
            return True


def findWinner(boards, draw):
    for num in draw:
        n = 0
        for board in boards:
            for i in range(25):
                if board[i] == num:
                    board[i] = -1
            if isWinner(board):
                return board, num
            n += 1
    return [], 0


def findLoser(boards, draw):
    for num in draw:
        for board in boards[:]:
            for i in range(25):
                if board[i] == num:
                    board[i] = -1
            if isWinner(board):
                if len(boards) == 1:
                    return board, num
                boards.remove(board)
    return [], 0


winner, winningnr = findWinner(boards, draw)

res = 0
for num in winner:
    if num != -1:
        res += num

res *= winningnr
print(res)

loser, winningnr = findLoser(boards, draw)


res = 0
for num in loser:
    if num != -1:
        res += num

res *= winningnr
print(res)
