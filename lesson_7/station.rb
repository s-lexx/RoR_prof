require_relative 'instance_counter'
require_relative 'validation'

class Station
  include InstanceCounter
  include Validation
  attr_reader :trains, :name

  @@all = []
  
  def initialize(name)
    @name = name
    @trains = []
    @@all << self
    register_instance
  end

  def self.all                    
    @@all 
  end  

  def accept_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end  

  def trains_by_name
    trains.map {|train| train.name}
  end

  def trains_by_type
    trains.group_by {|train| train.type}.each {|k, v| puts "#{k}: #{v.size}"} 
  end

  def station_trains(&block)
    trains.each {|train| block.call(train)}
  end

end