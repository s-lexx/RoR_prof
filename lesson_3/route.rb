class Route
  attr_accessor :other_stations
  attr_reader :start_st, :end_st

  def initialize(start_st, end_st)
    @start_st = start_st
    @end_st = end_st
    @other_stations = []    
  end

  def add_station(station)
    self.other_stations << station 
  end  

  def delete_station(station)
    self.other_stations.delete(station)
  end

  def stations_list
    puts self.start_st
    self.other_stations.each {|station| puts station} 
    puts self.end_st
  end  

end