# frozen_string_literal: true

require_relative '../../../lib/railway'
require_relative '../../../lib/railway/cargo_wagon'

describe Railway::CargoWagon do
  let(:cargo_wagon) { described_class.new 45 }
  let(:cargo_wagon_nil) { described_class.new nil }

  describe '#validation' do
    it("Wagon's volume can't be nil") { expect { cargo_wagon_nil.total_places }.to raise_error(RuntimeError) }

    it('Wagon\'s volume must be positive') do
      expect { described_class.new(-10) }.to raise_error("Wagon's volume should be a positive")
    end

    it("Wagon's volume can't be zero") do
      expect { described_class.new 0 }.to raise_error("Wagon's volume should be a positive")
    end
  end
end
