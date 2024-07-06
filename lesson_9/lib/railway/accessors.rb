# frozen_string_literal: true
require_relative 'validation'

module Accessors
  def self.included(base)
    base.include Validation
    base.extend ClassMethods
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = :"@#{name}"
        history_var_name = :"@#{name}_history"
        history_var = []
        define_method(name) { instance_variable_get(var_name) }
        define_method(:"#{name}=") do |value|
          instance_variable_set(var_name, value)
          history_var << value
          instance_variable_set(history_var_name, history_var)
        end
        define_method(:"#{name}_history") { instance_variable_get(history_var_name) }
      end
    end

    def strong_attr_accessor(attr_name, attr_class)
      name = :"@#{attr_name}"
      define_method(attr_name) { instance_variable_get(name) }
      define_method(:"#{attr_name}=".to_sym) do |value|
        raise 'wrong type' unless value.instance_of?(attr_class)

        instance_variable_set(name, value)
      end
    end
  end
end
