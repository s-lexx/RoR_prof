require_relative 'manufacturer'
require_relative 'validation'

class Wagon
  include Manufacturer
  include InstanceCounter
  attr_reader :type

end