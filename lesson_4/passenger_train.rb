class PassengerTrain < Train
  def initialize(name)
    @name = name
    @speed = 0
    @wagons = []    
    @route = [] 
    @type = :passenger    
  end
  
end