class PassengerWagon < Wagon
  def initialize(total_places)
    super
    @type = :passenger    
  end

  def take_place
    @used_places += 1 if used_places < total_places
  end

end