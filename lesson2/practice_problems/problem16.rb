# A UUID is a type of identifier often used as a way to uniquely identify
# items...which may not all be created by the same system. That is, without any
# form of synchronization, two or more separate computer systems can create new
# items and label them with a UUID with no significant chance of stepping on
# each other's toes.

# It accomplishes this feat through massive randomization. The number of
# possible UUID values is approximately 3.4 X 10E38.

# Each UUID consists of 32 hexadecimal characters, and is typically broken into
# 5 sections like this 8-4-4-4-12 and represented as a string.

# It looks like this: "f65c57f6-a6aa-17a8-faa1-a67f2dc9fa91"

# Write a method that returns one UUID when called with no parameters.

# p
# Generate a random UUID string

# Rules
# Input: N/A
# Output: String
# - 32 hex characters in 8-4-4-4-12 pattern
# - all characters should be random 0-9 , a-f

# e
# "f65c57f6-a6aa-17a8-faa1-a67f2dc9fa91"

# d
# array [8,4,4,4,12] pattern
# integer
# string output

# a
# - Given array [8, 4, 4, 4, 12]
# - Iterate over array generating random element byte number for each element
# - Iterate over random array and convert to hex string
# - join hex string array with '-' in between
# - return string

PATTERN = [8, 4, 4, 4, 12]

def generate_uuid()
  hex_arr = PATTERN.map do |bytes|
    num = rand(0...16**bytes)
    format("%0#{bytes}x", num)
  end
  hex_arr.join('-')
end
