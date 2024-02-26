module InstanceCounter
  
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods 
  end

  module ClassMethods
    attr_accessor :instance_count

    def instances
      @instance_count ||= 0
      
      #{}p "instanace count #{@instance_count}"
    end

    def incrase_instance
      #{}instances if @instance_count.nil?
      @instance_count += 1 
    end
    
  end

  module InstanceMethods

  private
    def register_instance
      self.class.instances if self.class.instance_count.nil?      
      self.class.instance_count += 1
    end

  end
  
end