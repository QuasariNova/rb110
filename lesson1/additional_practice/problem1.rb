# Given the array below

flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]

# Turn this array into a hash where the names are the keys and the values are
# the positions in the array.

flint_hash = flintstones.each_with_index.with_object({}) do
  |(name, index), hash|
  hash[name] = index
end

p flint_hash
