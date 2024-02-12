class PassengerTrain < Train
  def initialize(name)
    set_value(name)
    @type = :passenger    
  end
  
  def add_wagon(wagon)
    add_wagon_b(wagon) if wagon.is_a?(PassengerWagon)
  end
end