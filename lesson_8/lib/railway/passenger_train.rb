# frozen_string_literal: true

module Railway
  class PassengerTrain < Train
    def initialize(number, name)
      super
      @type = :passenger
    end
  end
end
