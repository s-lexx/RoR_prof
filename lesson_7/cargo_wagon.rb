class CargoWagon < Wagon
  def initialize(volume)
    super
    @type = :cargo
    
  end  

  def take_volume(volume)
    @used_places += volume if used_places + volume < total_places 
  end  

end