# How would you order this array of number strings by descending numeric value?

arr = ['10', '11', '9', '7', '8']

# either
p arr.sort { |a, b| b.to_i <=> a.to_i }
# or
p arr.sort_by { |ele| ele.to_i }.reverse
