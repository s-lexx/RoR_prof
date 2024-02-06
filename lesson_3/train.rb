class Train
  attr_reader :route, :current_station_index, :name, :type

  def initialize(name, type, number)
    @name = name
    @type = type
    @wagon_number = number
    @speed = 0
    @route = []    
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

  def delete_wagon
    @wagon_number -= 1 if @speed == 0
  end

  def add_wagon
    @wagon_number += 1 if @speed == 0
  end 

  def wagon_number
    @wagon_number
  end

  def set_route(route)
    @route = route
    @current_station_index = 0
    #{}self.current_station    #.send_train(self)
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

end
