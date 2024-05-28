# frozen_string_literal: true

require_relative '../../../lib/railway/route'

describe Railway::Route do
  context 'validation' do
    it("Station's names should be at least 6 symbols") do
      expect { described_class.new('station_1', 'sta_2') }.to raise_error("Station's name should be at least 6 symbols")
    end

    it("Station's names must be uniqueness") do
      expect { described_class.new('station', 'station') }.to raise_error('The starting and ending stations of route should be different')
    end
  end
end
