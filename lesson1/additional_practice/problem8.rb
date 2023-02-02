# What happens when we modify an array while we are iterating over it? What
# would be output by this code?

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.shift(1)
end

# This will ouptut 1 then 3. This is because it iterates by index. We check
# we check index 0, it prints it then shifts it out. 2 is now index 0, so
# when we do the next iteration it's on index 1, which is 3 now. Same thing
# happens and the length is now 2, so it can't keep iterating.

# What would be output by this code?

numbers = [1, 2, 3, 4]
numbers.each do |number|
  p number
  numbers.pop(1)
end

# This will output 1 then 2. This is for similar reasons, but after two
# iterations, the collection will be size 2, thus stop iterating.
