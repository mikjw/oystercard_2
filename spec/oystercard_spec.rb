require 'oystercard'

describe Oystercard do

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

    it 'will decrease when fare is charged' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect{ subject.deduct 1}.to change{ subject.balance }.by -1
    end
  end

  describe 'journey' do

    it { is_expected.to respond_to(:in_journey?) }
    
  end
end
