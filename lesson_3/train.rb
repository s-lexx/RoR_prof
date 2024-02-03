class Train

  attr_accessor :speed, :route, :current_station
  attr_reader :wagon_number, :name, :cargo_type 

  def initialize(name, type, number)
    @name = name
    @cargo_type = type
    @wagon_number = number
    @speed = 0
    @route = []
    @current_station    
  end

  def incrase_speed(speed)
    @speed = speed
  end

  def stop_train
    @speed = 0
  end

  def change_wagon_number(change)
    msg = ''
    unless @speed > 0
      
      if change == '+' 
        @wagon_number += 1
        msg = "К поезду прицеплен вагон"
      elsif change == '-'
        @wagon_number -= 1
        msg = "От поезда отцеплен вагон"
      else 
        msg = "Указано неверное действие"  
      end    
      
    end

    msg = 'Скорость поезда больше 0' if @speed > 0

    puts msg
  end

  def set_route(route)
    self.route = route.other_stations.unshift(route.start_st).push(route.end_st)
    puts self.route
    self.current_station = route.start_st
  end
  
  def next_station(forward_back)
    if forward_back == '+' && self.current_station != self.route.last      
      self.current_station = self.route[self.route.index(self.current_station) + 1]      
    elsif forward_back == '-'  && self.current_station != self.route.first
      self.current_station = self.route[self.route.index(self.current_station) - 1]
    end

    puts "Поезд прибыл в #{self.current_station} станцию"
  end

  def stations_info
    curr_index = self.route.index(self.current_station)
    puts "Поезд на станции #{self.current_station}, предыдущая станция: #{self.route[curr_index - 1]}, 
    следующая: #{self.route[curr_index + 1]}"
  end
end
