# frozen_string_literal: true

require_relative 'instance_counter'

module Railway
  class Route
    include InstanceCounter

    attr_reader :stations

    def initialize(start_station, end_station)
      @stations = [start_station, end_station]
      valid?
      register_instance
    end

    def add_station(station)
      @stations.insert(stations.size - 1, station)
    end

    def delete_station(station)
      @stations.delete(station)
    end

    def name_length_validation
      raise "Station's name should be at least 6 symbols" if stations.first.size < 6 || stations.last.size < 6
    end

    def check_uniqueness_edge_stations
      raise 'The starting and ending stations of route should be different' if stations.first == stations.last
    end

    def validate!
      name_length_validation
      check_uniqueness_edge_stations
    end

    def valid?
      validate!
    end

  end

end
