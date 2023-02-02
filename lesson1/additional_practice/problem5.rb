# In the array:

flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)

# Find the index of the first name that starts with "Be"

p(flintstones.each_with_index { |name, i| break i if name.start_with?('Be') })

# This will return the whole array if it doesn't find it. Launch School's
# solution is better, which is:

p(flintstones.index { |name| name.start_with? 'Be' })
