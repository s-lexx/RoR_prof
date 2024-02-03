class Station
  attr_accessor :trains 

  def initialize(name)
    @name = name
    @trains = []
  end

  def accept_train(train)
    self.trains << train
  end

  def send_train(train)
    self.trains.delete(train)
  end  

  def trains_by_names
    self.trains.each {|train| puts train.name}
  end

  def trains_by_types
    cargo_number = self.trains.select {|train| train.cargo_type == 1}.size
    puts "На станции #{cargo_number} грузовых и #{self.trains.size - cargo_number} пассажирских поездов"
  end
end