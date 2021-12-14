#!/usr/bin/env ruby
# frozen_string_literal: true

def apply_rules(poly, rules)
  new_map = Hash.new 0
  poly.each { |k, v| rules[k].each { |r| new_map[r] += v } }
  new_map
end

def do_count(poly, firstchar, lastchar)
  counts = Hash.new 0
  # first and last chars need to be added to final count, as
  # all other chars get counted twice
  counts[lastchar] += 1
  counts[firstchar] += 1
  poly.each { |k, v| k.split('').each { |c| counts[c] += v } }
  counts = counts.transform_values { |v| v / 2 }.values.sort
  counts[-1] - counts[0]
end

if __FILE__ == $PROGRAM_NAME
  file = File.open './input'
  polymer, rules = file.read.split "\n\n"
  file.close

  rules = rules.split("\n")
               .map { |v| v.split ' -> ' }
               .map { |k, v| [k, [k[0] + v, v + k[1]]] }
               .to_h

  firstchar = polymer[0]
  lastchar = polymer[-1]

  polymer = (0..polymer.length - 2).map { |i| polymer[i] + polymer[i + 1] }
  polymer = polymer.group_by { |e| e }.transform_values(&:length)

  10.times { polymer = apply_rules polymer, rules }

  puts do_count polymer, firstchar, lastchar

  30.times { polymer = apply_rules polymer, rules }

  puts do_count polymer, firstchar, lastchar
end
