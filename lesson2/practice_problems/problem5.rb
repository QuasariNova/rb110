# Consider this nested Hash:

munsters = {
  "Herman" => { "age" => 32, "gender" => "male" },
  "Lily" => { "age" => 30, "gender" => "female" },
  "Grandpa" => { "age" => 402, "gender" => "male" },
  "Eddie" => { "age" => 10, "gender" => "male" },
  "Marilyn" => { "age" => 23, "gender" => "female"}
}

# Determine the total age of just the male members of the family.

total_age = 0
munsters.each do |_, details|  # We can use each_value instead...
  total_age += details["age"] if details["gender"] == "male"
end

p total_age
