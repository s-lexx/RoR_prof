puts "Введите первую сторону"
side_one = gets.chomp.to_f
puts "Введите вторую сторону"
side_two = gets.chomp.to_f
puts "Введите третью сторону"
side_three = gets.chomp.to_f

max_side, other_sides  =
  if side_one > side_two && side_one > side_three
    [side_one, (side_two ** 2 + side_three**2)]
  elsif side_one < side_two && side_two > side_three
    [side_two, (side_one**2 + side_three**2)]
  elsif side_one < side_three && side_two < side_three
    [side_three, (side_two ** 2) + (side_one ** 2)]
  else
    [0,0]
  end

result =
  if max_side ** 2 == other_sides && side_one != side_two &&
    side_two != side_three
    "Треугольник прямоугольный"
  elsif side_one == side_two && side_two == side_three
    "Треугольник равносторонний"
  elsif side_one == side_two || side_two == side_three ||side_one == side_three
    "Треугольник равнобедренный"
  else
    "Треугольник не прямоугольный"
  end

puts result
