#!/usr/bin/env ruby

if __FILE__ == $0
  file = File.open("./input")
  input = file.read().split("\n")
  file.close()

  opener = ["(", "[", "{", "<"]
  closer = [")", "]", "}", ">", nil]
  scoreA = [3, 57, 1197, 25137, 0]
  scoreB = [1, 2, 3, 4]

  corrupted = input.map {|l| l.split("").reduce([nil, []]) do |acc, c|
      if acc[0] != nil
        acc
      elsif opener.include?(c)
        [nil, acc[1] << c]
      elsif acc[1][-1] == opener[closer.index(c)]
        [nil, acc[1][0..-2]]
      else
        [c]
      end
  end}.map {|l| l[0]}.map {|c| scoreA[closer.index(c)]}

  # Part 1 result
  puts corrupted.sum()

  missing = input.filter.with_index { |e, i|
    corrupted[i] == 0
  }.map{|l| l.split("").reduce([]) {|acc, c|
      opener.include?(c) ? acc << c : acc[0..-2]
    }.reverse().map {|c| scoreB[opener.index(c)]} .reduce(0) {|s, v| s * 5 + v }
    }.sort()

  # Part 2 result
  puts missing[(missing.length / 2).floor()]
end


