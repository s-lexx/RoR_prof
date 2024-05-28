# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'manufacturer'

module Railway
  class Train
    include InstanceCounter
    include Manufacturer
    attr_reader :route, :current_station_index, :type, :wagons_number, :wagons
    attr_accessor :number, :name

    NUMBER_FORMAT = /^[0-9а-я]{3}-?[0-9a-я]{2}$/i

    @@trains = []

    def self.all
      @@trains
    end

    def self.find(name)
      @@trains.find { |train| train.name == name }
    end

    def initialize(number, name)
      @number = number
      @name = name
      valid?
      @speed = 0
      @wagons = []
      @route = []
      @@trains << self
      register_instance
    end

    def increase_speed(speed)
      @speed += speed
    end

    def stop_train
      @speed = 0
    end

    def current_speed
      @speed
    end

    def delete_wagon(wagon)
      @wagons.delete_at(wagon) if @speed.zero?
    end

    def wagons_number
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

    def add_wagon(wagon)
      @wagons << wagon if @speed.zero? && wagon.type == type
    end

    def train_wagons(&block)
      @wagons.each(&block)
    end

    def valid?
      validate!
    end

    def check_number_nil
      raise "Number can't be nil" if number.nil?
    end

    def check_number_format
      raise 'Number has invalid format' unless Train::NUMBER_FORMAT.match?(number)
    end

    def check_name
      raise "Name can't be nil" if name.nil?
    end

    def check_name_size
      raise "Name should be at least 6 symbols" if name.size < 6
    end

    def validate!
      check_number_nil
      check_name
      check_name_size
      check_number_format
    end

  end
end
