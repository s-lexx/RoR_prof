class CargoTrain < Train
  def initialize(name)
    @name = name
    @speed = 0
    @wagons = []    
    @route = [] 
    @type = :cargo    
  end
  
end