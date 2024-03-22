module Validation 
  
  def valid?
    validate!     
  rescue
    false        
  end

  def validate!
       
    unless self.is_a?(Route)
      raise "Name should be at least 6 symbols" if name.size < 6        
    end

    case 
      when self.class.name == 'Route'
        raise "Start or end station can't be nill" if self.stations_list.first.nil? || self.stations_list.last.nil?
        raise "Start's or end's stations name should be at least 6 symbols" if stations_list.first.length < 6 || 
          self.stations.last.length < 6     
      when self.class.superclass == Train || self.is_a?(Train)
        raise "Number can't be nill" if number.nil?
        raise "Number should be at least 6 symbols" if number.size < 6 || number.size > 7
        raise "Number has invalid format" if number !~ Train::NUMBER_FORMAT
        true    
      end
    end
end
