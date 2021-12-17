package main

import (
    "fmt"
    "io/ioutil"
    "strings"
    "strconv"
)

func readBits(bits []bool, start int, length int) (int, int) {
    byte := ""
    for i := start; i < start + length; i++ {
        if bits[i] {
            byte += "1"
        } else {
            byte += "0"
        }
    }

    v, _ := strconv.ParseInt(string(byte), 2, 64)

    return int(v), (start + length)
}

func readLiteral(bits []bool, start int) (int, int) {
    cont := 1
    ptr := start
    literal := 0

    for cont == 1 {
        literal = literal << 4
        cont, ptr = readBits(bits, ptr, 1)
        tmp := 0
        tmp, ptr = readBits(bits, ptr, 4)
        literal += tmp
    }

    return ptr, literal
}

func readSubPackages(bits []bool, start int) (int, []int) {
    ptr := start
    var values []int
    tmp := 0
    lengthType, ptr := readBits(bits, ptr, 1)

    if lengthType == 0 {
        bitLength := 0
        bitLength, ptr = readBits(bits, ptr, 15)
        
        ptrStart := ptr

        for ptr - ptrStart != bitLength {
            ptr, tmp = readPackage(bits, ptr)
            values = append(values, tmp)
        }
    } else {
        numPackages := 0
        numPackages, ptr = readBits(bits, ptr, 11)

        for i := 0; i < numPackages; i++ {
            ptr, tmp = readPackage(bits, ptr)
            values = append(values, tmp)
        }
    }

    return ptr, values
}

func readPackage(bits []bool, start int) (int, int) {
    ptr := start
    res := 0

    _, ptr = readBits(bits, ptr, 3)
    pkgType, ptr := readBits(bits, ptr, 3)

    if pkgType == 4 {
        return readLiteral(bits, ptr)
    } else {
        var values []int
        ptr, values = readSubPackages(bits, ptr)

        switch pkgType {
        case 0:
            for _, v := range values {
                res += v
            }
        case 1:
            res = 1
            for _, v := range values {
                res *= v
            }
        case 2:
            res = values[0]
            for _, v := range values {
                if v < res {
                    res = v
                }
            }
        case 3:
            res = values[0]
            for _, v := range values {
                if v > res {
                    res = v
                }
            }
        case 5:
            if values[0] > values[1] {
                res = 1
            } else {
                res = 0
            }
        case 6:
            if values[0] < values[1] {
                res = 1
            } else {
                res = 0
            }
        case 7:
            if values[0] == values[1] {
                res = 1
            } else {
                res = 0
            }
        } 
    }

    return ptr, res
}

func main() {
    input, _ := ioutil.ReadFile("./input")
    trimmedInput := strings.TrimSuffix(string(input), "\n")
    bits := make([]bool, len(trimmedInput) * 4)

    for i, s := range trimmedInput {
        tmp, _ := strconv.ParseUint(string(s), 16, 4)
        for j, b := range fmt.Sprintf("%04b", tmp) {
            bits[i * 4 + j] = b == '1'
        }
    }

    fmt.Println(readPackage(bits, 0))
}
