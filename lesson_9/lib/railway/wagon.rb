# frozen_string_literal: true

module Railway
  class Wagon
    include Manufacturer
    include InstanceCounter
    include Validation
    attr_reader :type, :total_places, :used_places

    validate :total_places, :presence
    validate :total_places, :format, /^[1-9][0-9]*$/

    def initialize(total_places)
      @total_places = total_places
      @used_places = 0
      validate!
    end

    def free_places
      total_places - used_places
    end
  end
end
