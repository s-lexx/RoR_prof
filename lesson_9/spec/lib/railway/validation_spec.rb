# frozen_string_literal: true

require_relative '../../../lib/railway/validation'
class DummyClass
  include Validation

  attr_writer :presence_variable, :format_variable, :type_variable

  validate :presence_variable, :presence
  validate :format_variable, :format, /[0-9]+/
  validate :type_variable, :type, Integer

  def initialize
    @presence_variable = '1'
    @format_variable = '11'
    @type_variable = 1
  end
end

describe Validation do
  let!(:test_invalid) { DummyClass.new }
  let!(:test_valid) { DummyClass.new }

  context 'presence validation' do
    before do
      test_invalid.presence_variable = nil
    end

    describe '.validate!' do
      it('raises error when name is nil') do
        expect { test_invalid.validate! }.to raise_error("presence_variable can't be nil")
      end

      it('accepts valid value') do
        expect(test_valid.validate!).to be_truthy
      end
    end

    describe '.valid?' do
      it('should be false when invalid') do
        expect(test_invalid.valid?).to be_falsey
      end

      it('should be true when valid') do
        expect(test_valid.valid?).to be_truthy
      end
    end
  end

  context 'format validation' do
    before do
      test_invalid.format_variable = 'abc'
    end

    describe '.validate!' do
      it('raises error when format is invalid') do
        expect { test_invalid.validate! }.to raise_error("format_variable's value doesn't match with mask")
      end

      it('accepts valid value') do
        expect(test_valid.validate!).to be_truthy
      end
    end

    describe '.valid?' do
      it('should be false when invalid') do
        expect(test_invalid.valid?).to be_falsey
      end

      it('should be true when valid') do
        expect(test_valid.valid?).to be_truthy
      end
    end
  end

  context 'type validation' do
    before do
      test_invalid.type_variable = 'abc'
    end

    describe '.validate!' do
      it('raises error when format is invalid') do
        expect { test_invalid.validate! }.to raise_error("type_variable isn't a instance of Integer")
      end

      it('passes validation with correct type') do
        expect(test_valid.validate!).to be_truthy
      end
    end

    describe '.valid?' do
      it('should be false when invalid') do
        expect(test_invalid.valid?).to be_falsey
      end

      it('should be true when valid') do
        expect(test_valid.valid?).to be_truthy
      end
    end
  end
end


