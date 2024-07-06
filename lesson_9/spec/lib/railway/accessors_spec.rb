# frozen_string_literal: true

require_relative '../../../lib/railway/accessors'

class TestAccessor
  include Accessors
  attr_accessor_with_history :a
  strong_attr_accessor :b, Integer
end

describe Accessors do
  subject(:ta) { TestAccessor.new }

  context 'attr_accessor_with_history' do
    it("saves value's and history") do
      ta.a = 1
      expect(ta.a).to eq(1)
      ta.a = 2
      expect(ta.a).to eq(2)
      expect(ta.a_history).to eq([1, 2])
    end
  end

  context 'strong_attr_accessor' do
    it('raises error if type not match') do
      expect { ta.b = '' }.to raise_error('wrong type')
    end

    it('allows correct value') do
      ta.b = 1
      expect(ta.b).to eq 1
    end
  end
end
