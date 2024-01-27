puts "What's your name"
user_name = gets.chomp
puts "What's your height in centimetres"
user_height = gets.chomp.to_i
ideal_weight = (user_height - 110) * 1.15

puts ideal_weight.positive? ? "Your ideal weight is #{ideal_weight}" :
  "Your weight is ideal already"
