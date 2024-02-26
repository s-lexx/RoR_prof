class PassengerTrain < Train
 include InstanceCounter

  def initialize(name)
    super    
    @type = :passenger    
  end 

end