class CargoTrain < Train
  
  def initialize(number, name)    
    super
    @type = :cargo    
  end
  
end