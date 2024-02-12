class Train # т.к. большинство методом мы будеть использовать на обьекте класса, то оставляем все в public
  attr_reader :route, :current_station_index, :name, :type, :wagon_number
  def initialize(name)
      set_value(name)  
  end
    
  def incrase_speed(speed)
    @speed += speed
  end

  def stop_train
    @speed = 0
  end

  def current_speed
    @speed
  end

  def delete_wagon(wagon)
    @wagons.delete_at(wagon) if @speed == 0
  end

  def wagon_number
    @wagons.size
  end

  def set_route(route)
    @route = route
    @current_station_index = 0    
  end

  def current_station    
    @route.stations[current_station_index]
  end

  def next_station
    @route.stations[current_station_index + 1] 
  end

  def previous_station
    @route.stations[current_station_index - 1] 
  end

  def go_next_station
    @current_station_index += 1 if next_station
  end

  def go_previous_station
    @current_station_index -= 1 if previous_station
  end
  
  protected #используется защищенные методы чтобы использовать их в производных классах
  
  def set_value(name)
    @name = name
    @speed = 0
    @wagons = []    
    @route = []        
  end

  def add_wagon_b(wagon)
    @wagons << wagon if @speed == 0
  end

end