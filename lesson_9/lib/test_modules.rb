# frozen_string_literal: true

require_relative 'railway/accessors'
require_relative 'railway/validation'

class A
  include Validation

  attr_accessor :presence_variable, :format_variable, :type_variable

  validate :presence_variable, :presence
  validate :format_variable, :format, /[0-9]+/
  validate :type_variable, :type, Integer

  def initialize
    @presence_variable = nil
    @format_variable = ''
    @type_variable = 'abc'
  end
end

class B < A
  include Accessors
  attr_accessor_with_history :a1
  strong_attr_accessor :b, Integer
end

def check(instance)
  instance.validate!
  rescue StandardError => e
    puts "Проверка не пройдена! #{e.message}"
  else
    puts "Проверка пройдена"
end

def test
  test_instance = B.new
  puts "тестирование валидаций"
  1.upto(4) do |step|
    check(test_instance)
    test_instance.presence_variable = '3' if step == 1
    test_instance.format_variable = '13' if step == 2
    test_instance.type_variable = 20 if step == 3
  end

  puts "тестирование атрибутов"
  test_instance.a1 = 3
  test_instance.a1 = 10
  test_instance.a1 = 7
  puts "attr_history => #{test_instance.a1_history}"

  puts "тестирование strong_attr_accessor"
  test_instance.b = '1'
rescue StandardError => e
  puts e.message
  test_instance.b= 1
  puts test_instance.b
end

