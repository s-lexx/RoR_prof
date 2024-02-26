class CargoTrain < Train
 include InstanceCounter
 
  def initialize(name)    
    super
    @type = :cargo    
  end
  
end