require_relative 'instance_counter'

class Route
  include InstanceCounter
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]    
    register_instance
  end

  def add_station(station)    
    @stations.insert(stations.size - 1, station)
  end  

  def delete_station(station)
    @stations.delete(station)
  end

  def stations_list
    @stations     
  end  

end