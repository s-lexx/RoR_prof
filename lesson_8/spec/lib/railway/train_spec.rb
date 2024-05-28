# frozen_string_literal: true

require_relative '../../../lib/railway/train'

describe Railway::Train do
  subject(:train) { described_class.new '001-ск', 'Кисловодск' }

  context 'validation' do
    it('raises error when train number is nil') { expect { described_class.new nil, 234 }.to raise_error("Number can't be nil") }
    it('raises error when train name is nil') { expect { described_class.new 'с01-ск', nil }.to raise_error("Name can't be nil") }

    it('raises error when train number shorter than 6 symbols') do
      expect { described_class.new 'a1', '123456' }.to raise_error('Number has invalid format')
    end

    it('raises error when train number longer than 7 symbols') do
      expect { described_class.new '123-456', '123456' }.to raise_error('Number has invalid format')
    end

    it('raises error when train name shorter than 6 symbols') do
      expect { described_class.new '123-a1', '123' }.to raise_error('Name should be at least 6 symbols')
    end
  end

  describe '#instances' do
    it 'returns correct number of instances' do
      5.times { described_class.new 'с01-ск', 123 }
      expect(described_class.instances).to eq 5
    end
  end

  describe 'speed after creating' do
    it('should be zero') { expect(train.current_speed).to eq 0 }
  end

  context 'movements methods' do
    describe '#incrase_speed' do
      it do
        train.increase_speed(25)
        expect(train.current_speed).to eq 25
      end
    end

    describe '#stop_train' do
      it do
        train.increase_speed(30)
        train.stop_train
        expect(train.current_speed).to eq 0
      end
    end
  end
end
