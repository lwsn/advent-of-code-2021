#!/usr/bin/env ruby

if __FILE__ == $0
  file = File.open("./input")
  input = file.read().split(",").map(&:to_i).sort()
  file.close()

  median = input[input.length() / 2]

  puts input.reduce(0) { |sum, n| sum + (median - n).abs() }

  puts (input[0]..input[-1]).reduce(2**31-1) {
    |small, v| [
      input.reduce(0) { |sum, n| sum + (((v - n).abs() * ((v - n).abs() + 1))/2) },
      small
    ].min()
  }
end

