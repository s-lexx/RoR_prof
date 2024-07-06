# frozen_string_literal: true

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(atr_name, type, params = nil)
      validations << { name: atr_name, type: type, params: params }
    end

    def validations
      @validations ||= []
    end
  end

  module InstanceMethods
    def valid?
      validate!
    rescue StandardError
      false
    end

    def validate!
      src = self.class.superclass == Object ? self.class : self.class.superclass
      src.validations.each { |validation| send(validation[:type], validation[:name], validation[:params]) }
      true
    end

    private

    def instance_var(arg)
      instance_variable_get(:"@#{arg}")
    end

    def presence(arg, _)
      raise "#{arg} can't be nil" if instance_var(arg).nil? || (instance_var(arg).is_a?(String) && instance_var(arg).empty?)
    end

    def format(arg, mask)
      raise "#{arg}'s value doesn't match with mask" unless mask.match?(instance_var(arg))
    end

    def type(arg, type)
      raise "#{arg} isn't a instance of #{type}" unless instance_var(arg).is_a?(type)
    end
  end
end
