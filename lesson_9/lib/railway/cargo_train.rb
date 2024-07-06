# frozen_string_literal: true

module Railway
  class CargoTrain < Train
    def initialize(number, name)
      super
      @type = :cargo
    end
  end
end
