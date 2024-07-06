# frozen_string_literal: true

require_relative '../../../lib/railway/route'
require_relative '../../../lib/railway/validation'

describe Railway::Route do
  context 'validation' do
    it("Station's names should be at least 6 symbols") do
      expect { described_class.new('Стан1', 'станция2') }.to raise_error("start_station's value doesn't match with mask")
    end
  end
end
