class CargoTrain < Train
  def initialize(name)
    @type = :cargo
    set_value(name)
  end
  
  def add_wagon(wagon)
    self.add_wagon_b(wagon) if wagon.is_a?(CargoWagon)
  end
end