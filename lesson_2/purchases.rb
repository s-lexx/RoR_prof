basket = {}
total = 0

loop do
  puts "Введите наименование товара"
	name = gets.chomp

	break if name == "стоп"  

	puts "Введите цену товара"
	price = gets.chomp.to_i
	puts "Введите количество купленного товара"
	volume = gets.chomp.to_f
	basket[name] = {цена: price, количество: volume} 
end

basket.each do |k, v|
	by_name = v[:цена] * v[:количество]
	puts "итоговая сумма за #{k}: #{by_name}"
	total += by_name		
end

puts "Общая стоимость: #{total}"