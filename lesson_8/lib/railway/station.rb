# frozen_string_literal: true

require_relative 'instance_counter'

module Railway
  class Station
    include InstanceCounter

    attr_reader :trains, :name

    @@all = []

    def initialize(name)
      @name = name
      valid?
      @trains = []
      @@all << self
      register_instance
    end

    def self.all
      @@all
    end

    def accept_train(train)
      trains << train
    end

    def send_train(train)
      trains.delete(train)
    end

    def trains_by_name
      trains.map(&:name)
    end

    def trains_by_type
      trains.group_by(&:type).each { |k, v| puts "#{k}: #{v.size}" }
    end

    def station_trains(&block)
      trains.each(&block)
    end

    def check_name_nil
      raise "Station name can't be nil" if name.nil?
    end

    def check_name_size
      raise 'Station name should be at least 6 symbols' if name.size < 6
    end

    def valid?
      validate!
    end

    def validate!
      check_name_nil
      check_name_size
    end

  end

end
