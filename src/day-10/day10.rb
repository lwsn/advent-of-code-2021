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
        next acc
      elsif opener.include?(c)
        next [nil, acc[1] << c]
      elsif acc[1][-1] == opener[closer.index(c)]
        next [nil, acc[1][0..-2]]
        else
        next [c]
      end
  end}.map {|l| l[0]}.map {|c| scoreA[closer.index(c)]}

  # Part 1 result
  puts corrupted.sum()

  missing = input.filter.with_index { |e, i|
    corrupted[i] == 0
  }.map{|l| l.split("").reduce([]) do |acc, c|
      if opener.include?(c)
        next acc << c
        else
        next acc[0..-2]
      end
    end}.map{|l|
      l.reverse().map {|c|
        scoreB[opener.index(c)]
      }.reduce(0) {|s, v| s * 5 + v }
    }.sort()

  # Part 2 result
  puts missing[(missing.length / 2).floor()]
end


