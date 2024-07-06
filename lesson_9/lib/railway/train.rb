# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'manufacturer'
require_relative 'validation'

module Railway
  class Train
    include InstanceCounter
    include Manufacturer
    include Validation
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

    validate :name, :presence
    validate :number, :presence
    validate :name, :format, /^[0-9А-Яа-я]{6,}$/
    validate :number, :format, NUMBER_FORMAT

    def initialize(number, name)
      @number = number
      @name = name
      validate!
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

  end
end
