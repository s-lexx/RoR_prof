# frozen_string_literal: true

require_relative '../../../lib/railway'
require_relative '../../../lib/railway/cargo_wagon'

describe Railway::CargoWagon do
  describe '#validation' do
    it("Wagon's volume can't be nil") { expect { described_class.new nil }.to raise_error("total_places can't be nil") }

    it('Wagon\'s volume must be positive') do
      expect { described_class.new("-10") }.to raise_error("total_places's value doesn't match with mask")
    end

    it("Wagon's volume can't be zero") do
      expect { described_class.new "0" }.to raise_error("total_places's value doesn't match with mask")
    end
  end
end
