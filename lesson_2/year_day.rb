days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
user_date = []
i = 0
year_day = 0

while i < 3
	puts "Введите #{i + 1}-е число"
	user_date[i] = gets.chomp.to_i
	i += 1  
end

i = 0

while i < user_date[1]
	year_day += days_in_months[i]
	i += 1		
end

if year_day > 59
	year_day += 1 if user_date[2] % 4 == 0 && user_date[2] % 100 && user_date[2] % 400
end

puts "Введенная дата #{year_day} день #{user_date[2]} года."