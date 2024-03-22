require_relative 'manufacturer'
require_relative 'validation'

class Wagon
  include Manufacturer
  include InstanceCounter
  attr_reader :type, :total_places, :used_places

  def initialize(total_places)
    @total_places = total_places
    @used_places = 0
  end  

  def free_places
    total_places - used_places
  end  
end