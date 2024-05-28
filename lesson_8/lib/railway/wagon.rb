# frozen_string_literal: true

module Railway
  class Wagon
    include Manufacturer
    include InstanceCounter
    attr_reader :type, :total_places, :used_places

    def initialize(total_places)
      @total_places = total_places
      @used_places = 0
      valid?
    end

    def free_places
      total_places - used_places
    end

    def check_volume_nil
      raise "Wagon's volume can't be nil" if total_places.nil?
    end

    def check_volume_positive
      raise "Wagon's volume should be a positive" unless total_places.positive?
    end

    def valid?
      validate!
    end

    def validate!
      check_volume_nil
      check_volume_positive

      true
    end

  end

end
