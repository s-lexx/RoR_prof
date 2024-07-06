# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'validation'

module Railway
  class Station
    include InstanceCounter
    include Validation

    attr_reader :trains, :name

    @@all = []

    validate :name, :presence
    validate :name, :format, /^[0-9а-яА-Я]{6,}$/

    def initialize(name)
      @name = name
      validate!
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

  end

end
