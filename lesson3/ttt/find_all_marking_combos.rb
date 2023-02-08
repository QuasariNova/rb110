# I am working on a method to find all combos to check with a magic square for
# tic tac toes. I need it to be able to work with any size square.

# This method is too slow for anything > 5 arrays
# def find_all_marking_combos(*arr)
#   return arr if single_layer?(arr)

#   new_arr = []

#   arr.first.product(*arr[1..-1]) do |combo|
#     new_arr << combo.sort if combo.uniq.size == arr.size
#   end

#   new_arr.uniq
# end

# def single_layer?(arr)
#   arr == arr.flatten
# end

# arr = [1, 2, 4, 9, 12, 15, 17, 19, 21]
# p find_all_marking_combos(arr, arr, arr)
# puts nil
# p find_all_marking_combos(arr, arr, arr, arr, arr)
# puts nil
# p find_all_marking_combos(arr, arr, arr, arr, arr, arr, arr)
# puts nil
# p find_all_marking_combos(arr, arr, arr, arr, arr, arr, arr, arr, arr)

# p
# using recursion, find all possible combinations of marks in marks of length
# marks_in_line

# Rules
# Input: integer, single layer array
# Output: Nested array. Second layer is single layer
# - Output must be a nested array with arrays of x size, which is every
#   combination of x size in the input array
# - If there are less elements in the input array than the square size, return
#   an empty array

# e
# find_all_marking_combos(3, [1]) == []
# find_all_marking_combos(3, [1, 2, 3, 4]) == [[1, 2, 3], [1, 2, 4], [1, 3, 4], #                                              [2, 3, 4]]
# find_all_marking_combos(5, [1, 2, 3, 4, 5]) == [[1, 2, 3, 4, 5]]

# d
# array

# a
# - Given a number of marks to make a line, marks_in_line, and a array of
#   marks, marks
# - Check if marks size is less than marks in a line and return an empty
#   array if so
# - Check if only one mark is needed to make a line and return marks if so
#   - This is because we are going ot recurse, so any of these can be added to
#     a higher level.
# - set variable position to 0 and out to an empty array
# - loop over array until you reach marks_in_lines elements from the end using
#   position
#   - Set variable first to the position element of marks as an array
#   - Recurse this method to the rest of the marks array and marks_in_line - 1
#   - Find the product of the first variable and the return of the recursive
#     call
#   - Flatten each sub array from the return value of the product
#   - Append the return value of that to out
#   - Increase position by 1
#   - loop back
# - return the array out

def find_all_marking_combos(marks_in_line, marks)
  return [] if marks.size < marks_in_line
  return marks if marks_in_line == 1

  position = 0
  out = []

  until position > marks.size - marks_in_line
    first = [marks[position]]
    rest = find_all_marking_combos(marks_in_line - 1, marks[(position + 1)..-1])
    out += first.product(rest).map { |sub| sub.flatten }

    position += 1
  end

  out
end

p find_all_marking_combos(3, [1]) == []
p find_all_marking_combos(3, [1, 2, 3, 4]) ==
  [[1, 2, 3], [1, 2, 4], [1, 3, 4], [2, 3, 4]]
p find_all_marking_combos(5, [1, 2, 3, 4, 5]) == [[1, 2, 3, 4, 5]]
puts nil

arr = [1, 2, 4, 9, 12, 15, 17, 19, 21]
p find_all_marking_combos(3, arr)
puts nil
p find_all_marking_combos(5, arr)
puts nil
p find_all_marking_combos(7, arr)
puts nil
p find_all_marking_combos(9, arr)
puts nil
p find_all_marking_combos(15, arr)
puts nil
