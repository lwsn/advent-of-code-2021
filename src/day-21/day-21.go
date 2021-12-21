package main

import (
    "fmt"
    "io/ioutil"
    "strings"
    "strconv"
)

func rollDice(start int) (int, int) {
    sum := 0
    for i := 0; i < 3; i++ {
        start = (start % 100) + 1
        sum += start
    }
    return sum, start
}

func part1(positions [2]int) {
    score := [2]int{ 0, 0 }
    diceRoll := 0
    numDice := 0
    player := 0

    for (score[0] < 1000 && score[1] < 1000) {
        steps := 0
        steps, diceRoll = rollDice(diceRoll)
        numDice += 3

        positions[player] = (positions[player] + steps - 1) % 10 + 1
        score[player] += positions[player]

        player = (player + 1) % 2
    }
    
    fmt.Println(score[player] * numDice)
}

func generateOutcomes() map[int]int {
    rolls := [3]int{1, 2, 3}
    outcomes := map[int]int {}

    for _, i := range rolls {
        for _, j := range rolls {
            for _, k := range rolls {
                outcomes[i+j+k] += 1
            }
        }
    }

    return outcomes
}

func doTurn(dice int, positions [2]int, scores [2]int, player int) (int,int) {
    positions[player] = (positions[player] + dice - 1) % 10 + 1
    scores[player] += positions[player]
    player = (player + 1) % 2

    if (scores[0] >= 21) {
        return 1, 0
    }
    if (scores[1] >= 21) {
        return 0, 1
    }

    p1score, p2score := 0, 0

    outcomes := map[int]int {3: 1, 4: 3, 5: 6, 6: 7, 7: 6, 8: 3, 9: 1}

    for i := range outcomes {
        p1, p2 := doTurn(i, positions, scores, player)
        p1score += p1 * outcomes[i]
        p2score += p2 * outcomes[i]
    }

    return p1score, p2score
}

func part2(positions [2]int) {
    p1, p2 := doTurn( 0, positions, [2]int{0, -positions[1]}, 1)

    if (p1 > p2) {
        fmt.Println(p1)
    } else {
        fmt.Println(p2)
    }
}

func main() {
    input, _ := ioutil.ReadFile("./input")

    startPos := [2]int{ 0, 0 }

    for i, s := range strings.Split(strings.TrimSuffix(string(input), "\n"), "\n") {
        tmp, _ := strconv.ParseInt(s[len(s)-1:], 10, 64)
        startPos[i] = int(tmp)
    }

    part1(startPos)
    part2(startPos)
}
