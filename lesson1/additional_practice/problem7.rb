# Create a hash that expresses the frequency with which each letter occurs in
# this string:

statement = "The Flintstones Rock"

# ex:
#
# { "F"=>1, "R"=>1, "T"=>1, "c"=>1, "e"=>2, ... }

# P
# Given a string, return a hash that denotes how many times each character
# appears in the string.
#
# Rules:
#   Characters are case sensitive
#   Character is key, times it appears is value
#
# E
# char_count("Hi") == { "H" => 1, "i" => 1 }
#
# Data structure:
# Array and Hash
#
# A
# Convert string to array of characters
# Create new hash with default value 0
# Iterate over character array adding 1 to Hash with key character
# return Hash

def char_count(string)
  count_hash = Hash.new(0)
  string.chars.each { |char| count_hash[char] += 1 }
  count_hash
end

p char_count("Hi") == { "H" => 1, "i" => 1 }
p char_count(statement)

# Launch Schools solution used an array of all possible letters and iterated
# over it, using #count on the string to check how many times each appears. My
# solution could do similar if I just filter out non characters, probably with
# a gsub prior to calling #chars
