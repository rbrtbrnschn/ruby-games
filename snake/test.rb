arr = [1,1,2,3,5,4,6,32,12,2]

ones = arr.select {|a| a == 32}
puts ones
puts ones.length
