# frozen_string_literal: true

require_relative '../../../lib/railway/station'
require_relative '../../../lib/railway/validation'

describe Railway::Station do
  let(:station) { described_class.new 'Кисловодск' }

  describe '#name' do
    it('returns station name') { expect(station.name).to eq('Кисловодск') }

    it("Station name can't be nil") do
      expect { described_class.new nil }.to raise_error(RuntimeError)
    end

    it('returns name should be at least 6 symbols') do
      expect { described_class.new 'a1' }.to raise_error(RuntimeError)
    end
  end
end
