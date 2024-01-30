m_names = %w[Январь Февраль Март Апрель Май Июнь Июль Август Сентябрь Октябрь Ноября Декабрь]
months = Hash.new

m_names.each do |month|
	if m_names.index(month) == 1
		months[month] = 28
	elsif m_names.index(month) == 3 || m_names.index(month) == 5 || m_names.index(month) == 8 || m_names.index(month) == 10
	 	months[month] = 30
	else	
		months[month] = 31
	end		
end 

  months.each do |k, v|
		puts k if v == 30
 	end	
	