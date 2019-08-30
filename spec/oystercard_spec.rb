require 'oystercard'

describe Oystercard do

  let(:station){double :station}
  let(:station2){double :station2}

  describe 'card balance' do

    it 'will start with a balance of 0' do
      expect(subject.balance).to eq 0
    end

    it 'will increase balance with top up' do
      expect(subject.top_up(5)).to eq 5
    end

    it 'will raise error if maximum balance is exceeded' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect { subject.top_up 1 }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end


  describe 'journey' do

    it { is_expected.to respond_to(:touch_in) }
    it { is_expected.to respond_to(:touch_out) }

    it 'raises error if balance is below minimum on touch in' do
      expect {subject.touch_in(station)}.to raise_error "Insufficient funds for journey"
    end

    it 'charges fare amount during touch out' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(station)
      expect{ subject.touch_out(station2) }.to change{ subject.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it 'stores entry station on touch in' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(station)
      expect(subject.journey_list[-1][:entry]).to eq(station)
    end
  end

  describe 'jouney history' do

    it 'has empty list of journeys by deafult' do
      expect(subject.journey_list).to eq([])
    end

    it 'saves entry station to history' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(station)
      expect(subject.journey_list[-1][:entry]).to eq(station)
    end

    it 'saves exit station to history' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(station)
      subject.touch_out(station)
      expect(subject.journey_list[-1][:exit]).to eq(station)
    end

    it 'creates a single journey' do
      subject.top_up(Oystercard::MAXIMUM_BALANCE)
      subject.touch_in(station)
      subject.touch_out(station)
      expect(subject.journey_list[-1]).to include(:entry => station, :exit => station)
    end
  end
end
