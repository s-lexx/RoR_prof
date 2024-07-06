# frozen_string_literal: true

require 'yaml'
require_relative '../../../lib/railway/task'

describe Railway::Task do
  let(:task) { described_class.new main_menu: { main: [[:create_station, 'Cозданиe станиций']] } }

  describe '#main_menu' do
    before do
      allow(task).to receive(:user_input).and_return 1
    end

    it 'returns a correct method' do
      expect(task.show_menu).to eq(:create_station)
    end
  end
end
