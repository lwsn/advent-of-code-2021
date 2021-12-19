#!/usr/bin/env ruby
# frozen_string_literal: true

class Pair
  attr_accessor :left, :right, :parent, :depth

  def initialize(parent, depth, left, right)
    @parent = parent
    @depth = depth
    @left = left.is_a?(Array) ? Pair.new(self, depth + 1, left[0], left[1]) : left
    @right = right.is_a?(Array) ? Pair.new(self, depth + 1, right[0], right[1]) : right
  end

  def inc_depth
    @depth += 1
    @left.inc_depth if @left.is_a?(Pair)
    @right.inc_depth if @right.is_a?(Pair)
  end

  def clone(parent)
    clone_pair = Pair.new(parent, @depth, nil, nil)
    clone_pair.left = @left.is_a?(Pair) ? @left.clone(clone_pair) : @left.clone
    clone_pair.right = @right.is_a?(Pair) ? @right.clone(clone_pair) : @right.clone
    clone_pair
  end

  def +(other)
    new_parent = Pair.new(nil, @depth, nil, nil)
    new_parent.left = clone(new_parent)
    new_parent.right = other.clone(new_parent)
    new_parent.left.inc_depth
    new_parent.right.inc_depth
    new_parent.left.parent = new_parent.right.parent = new_parent

    new_parent
  end

  def remove_child(child)
    if @left.equal? child
      @left = 0
    else
      @right = 0
    end
  end

  def find_parent_with_left_sibling
    return false if @parent.nil?

    @parent.left == self ? @parent.find_parent_with_left_sibling : @parent
  end

  def find_parent_with_right_sibling
    return false if @parent.nil?

    @parent.right == self ? @parent.find_parent_with_right_sibling : @parent
  end

  def add_to_closest_left
    ancestor = find_parent_with_left_sibling
    return unless ancestor

    if ancestor.left.is_a?(Pair)
      child = ancestor.left
      child = child.right while child.right.is_a?(Pair)
      child.right += @left
    else
      ancestor.left += @left
    end
  end

  def add_to_closest_right
    ancestor = find_parent_with_right_sibling
    return unless ancestor

    if ancestor.right.is_a?(Pair)
      child = ancestor.right
      child = child.left while child.left.is_a?(Pair)
      child.left += @right
    else
      ancestor.right += @right
    end
  end

  def do_explode
    return false unless @depth == 4

    add_to_closest_left
    add_to_closest_right

    @parent.remove_child self
    true
  end

  def try_explode
    do_explode || (@left.is_a?(Pair) && @left.try_explode) || (@right.is_a?(Pair) && @right.try_explode)
  end

  def split_left
    return @left.do_splits if @left.is_a?(Pair)

    if @left > 9
      @left = Pair.new(self, depth + 1, (@left / 2), @left - (@left / 2))
      return true
    end
    false
  end

  def split_right
    return @right.do_splits if @right.is_a?(Pair)

    if @right > 9
      @right = Pair.new(self, depth + 1, (@right / 2), @right - (@right / 2))
      return true
    end
    false
  end

  def do_splits
    split_left || split_right
  end

  def to_s
    "[#{@left}, #{@right}]"
  end

  def *(other)
    magnitude * other
  end

  def magnitude
    @left * 3 + @right * 2
  end

  def resolve
    while try_explode || do_splits
    end

    self
  end
end

def next_depth(char, depth)
  depth + (char == '[' && 1) || (char == ']' && -1) || 0
end

def root_comma_index(str)
  comma_index = 0
  depth = 0

  str.split('').each do |c|
    break if depth == 1 && c == ','

    depth = next_depth(c, depth)
    comma_index += 1
  end

  comma_index
end

def parse_pair(pair)
  return pair.to_i if pair.length == 1

  return [pair[1].to_i, pair[3].to_i] if pair.count(',') == 1

  comma_index = root_comma_index(pair)

  [
    parse_pair(pair[1..comma_index - 1]),
    parse_pair(pair[comma_index + 1..-2])
  ]
end

if __FILE__ == $PROGRAM_NAME
  file = File.open './input'
  input = file.read.split "\n"
  file.close

  input = input.map { |s| parse_pair s }.map { |v| Pair.new(nil, 0, v[0], v[1]) }

  puts input.reduce(nil) { |acc, s| (acc.nil? ? s : acc + s).resolve }.magnitude

  resb = input[0..-2].each_with_index.reduce(0) do |acc, (p, i)|
    [
      acc,
      (input[i + 1..-1].map do |p2|
        [(p + p2).resolve.magnitude, (p2 + p).resolve.magnitude].max
      end).max
    ].max
  end

  puts resb
end
