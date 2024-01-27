def get_value(coeff)
  puts "введите коэффициент #{coeff}"
  gets.chomp.to_f
end

names = %w[A B C]
values = Array.new
puts "Для квадратного уровнения (Ax*x + Bx + C)"

  names.each do |name|
    values.push(get_value(name))
  end

a = values[0]
b = values[1]
d = b**2 - 4 * a * values[2]

result =
   if d > 0
     den = 2 * a
     s_t = Math.sqrt(d)
    "уравнение имеет 2 решения: х1 = #{((-b + s_t) / den).round(2)},
      x2 = #{((-b - s_t) / den).round(2)}"
  elsif d.zero?
    "уравнение имеет 1 решениe: x = #{(-b / (2 * a)).round(2)}"
  else
    "корней нет"
  end

puts "Дискриминат равен #{d}, #{result}"
