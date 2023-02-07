# Improved "join"

# If we run the current game, we'll see the following prompt:

# => Choose a position to place a piece: 1, 2, 3, 4, 5, 6, 7, 8, 9

# This is ok, but we'd like for this message to read a little better. We want
# to separate the last item with a "or", so that it reads:

# => Choose a position to place a piece: 1, 2, 3, 4, 5, 6, 7, 8, or 9

# Currently, we're using the Array#join method, which can only insert a
# delimiter between the array elements, and isn't smart enough to display a
# joining word for the last element.

# Write a method called joinor that will produce the following result:

# joinor([1, 2])                   # => "1 or 2"
# joinor([1, 2, 3])                # => "1, 2, or 3"
# joinor([1, 2, 3], '; ')          # => "1; 2; or 3"
# joinor([1, 2, 3], ', ', 'and')   # => "1, 2, and 3"

# Then, use this method in the TTT game when prompting the user to mark a
# square.

# p
# Given an array of options, create a string that is a list of those options.
# Optionally you will be given a separator and a word, please use the default/
# optional parameters to separate the list smartly.

# Rules
# Input: Array of options(integers or strings)
# Output: String
# - If one option is given, the string is just that option
# - If two options are given, the string is separated by the word and a space
#   on either side of the word.
# - If three or more options are given, all but the last two options are
#   separated by the separater and a space, while the last is separated by the
#   separater, a space, the word, and another space.
# - If no options are given, it returns an empty string

# e
# joinor([]) == ""
# joinor([1]) == "1"
# joinor([1, 2]) == "1 or 2"
# joinor([1, 2, 3]) == "1, 2, or 3"
# joinor([1, 2, 3], '; ') == "1; 2; or 3"
# joinor([1, 2, 3], ', ', 'and') == "1, 2, and 3"

# d
# Array and String

# a
# - Given an array arr, a separater defaulted to ',', and a word defaulted to
#   'or'
# - Check arr's size
#   - if 0, return an empty string
#   - if 1, return it's element converted to a string
#   - If 2, return both elements separated by word
# - Join the first through the penultimate element using the separator
# - Combine the previous value with the separator, word, and final element
# - return that value

def joinor(arr, sep=', ', word='or')
  return '' if arr.size < 1
  return arr.first.to_s if arr.size == 1
  return "#{arr.first} #{word} #{arr.last}" if arr.size == 2
  "#{arr[0...-1].join(sep)}#{sep}#{word} #{arr.last}"
end

p joinor([]) == ""
p joinor([1]) == "1"
p joinor([1, 2]) == "1 or 2"
p joinor([1, 2, 3]) == "1, 2, or 3"
p joinor([1, 2, 3], '; ') == "1; 2; or 3"
p joinor([1, 2, 3], ', ', 'and') == "1, 2, and 3"
