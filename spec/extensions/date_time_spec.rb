require 'spec_helper'

describe Spree::DateTime do
  before do
    @today = Spree::DateTime.new Time.now
    @tomorrow = Spree::DateTime.new 1.day.from_now
    @always = Spree::DateTime.always
    @never = Spree::DateTime.never
  end
  describe '#always' do
    specify { @today.should_not be_always }
    specify { @tomorrow.should_not be_always }
    specify { @always.should be_always }
    specify { @never.should_not be_always }
  end
  describe '#never' do
    specify { @today.should_not be_never }
    specify { @tomorrow.should_not be_never }
    specify { @always.should_not be_never }
    specify { @never.should be_never }
  end
  describe '#>' do
    context 'today' do
      specify { @today.should_not > @today }
      specify { @today.should > @always }
      specify { @today.should_not > @never }
      specify { @today.should_not > @tomorrow }
    end

    context 'tomorrow' do
      specify { @tomorrow.should > @today }
      specify { @tomorrow.should > @always }
      specify { @tomorrow.should_not > @never }
      specify { @tomorrow.should_not > @tomorrow }
    end

    context 'always' do
      specify { @always.should > @today }
      specify { @always.should > @always }
      specify { @always.should > @tomorrow }
      it "should throw an error" do
        expect { @always > @never }.to raise_error Spree::DateTime::CausalityConflict
      end
    end

    context 'never' do
      specify { @never.should_not > @today }
      specify { @never.should_not > @never }
      specify { @never.should_not > @tomorrow }
      it "should throw an error" do
        expect { @never > @always }.to raise_error Spree::DateTime::CausalityConflict
      end
    end
  end

  describe '#>=' do
    context 'today' do
      specify { @today.should >= @today }
      specify { @today.should >= @always }
      specify { @today.should_not >= @never }
      specify { @today.should_not >= @tomorrow }
    end

    context 'tomorrow' do
      specify { @tomorrow.should >= @today }
      specify { @tomorrow.should >= @always }
      specify { @tomorrow.should_not >= @never }
      specify { @tomorrow.should >= @tomorrow }
    end

    context 'always' do
      specify { @always.should >= @today }
      specify { @always.should >= @always }
      specify { @always.should >= @tomorrow }
      it "should throw an error" do
        expect { @always >= @never }.to raise_error Spree::DateTime::CausalityConflict
      end
    end

    context 'never' do
      specify { @never.should_not >= @today }
      specify { @never.should_not >= @never }
      specify { @never.should_not >= @tomorrow }
      it "should throw an error" do
        expect { @never >= @always }.to raise_error Spree::DateTime::CausalityConflict
      end
    end
  end

  describe '#<' do
    context 'today' do
      specify { @today.should_not < @today }
      specify { @today.should < @always }
      specify { @today.should_not < @never }
      specify { @today.should < @tomorrow }
    end

    context 'tomorrow' do
      specify { @tomorrow.should_not < @today }
      specify { @tomorrow.should < @always }
      specify { @tomorrow.should_not < @never }
      specify { @tomorrow.should_not < @tomorrow }
    end

    context 'always' do
      specify { @always.should < @today }
      specify { @always.should < @always }
      specify { @always.should < @tomorrow }
      it "should throw an error" do
        expect { @always < @never }.to raise_error Spree::DateTime::CausalityConflict
      end
    end

    context 'never' do
      specify { @never.should_not < @today }
      specify { @never.should_not < @never }
      specify { @never.should_not < @tomorrow }
      it "should throw an error" do
        expect { @never < @always }.to raise_error Spree::DateTime::CausalityConflict
      end
    end
  end

  describe '#<=' do
    context 'today' do
      specify { @today.should <= @today }
      specify { @today.should <= @always }
      specify { @today.should_not <= @never }
      specify { @today.should <= @tomorrow }
    end

    context 'tomorrow' do
      specify { @tomorrow.should_not <= @today }
      specify { @tomorrow.should <= @always }
      specify { @tomorrow.should_not <= @never }
      specify { @tomorrow.should <= @tomorrow }
    end

    context 'always' do
      specify { @always.should <= @today }
      specify { @always.should <= @always }
      specify { @always.should <= @tomorrow }
      it "should throw an error" do
        expect { @always <= @never }.to raise_error Spree::DateTime::CausalityConflict
      end
    end

    context 'never' do
      specify { @never.should_not <= @today }
      specify { @never.should_not <= @never }
      specify { @never.should_not <= @tomorrow }
      it "should throw an error" do
        expect { @never <= @always }.to raise_error Spree::DateTime::CausalityConflict
      end
    end
  end

  describe '#==' do
    context 'today' do
      specify { @today.should == @today }
      specify { @today.should == @always }
      specify { @today.should_not == @never }
      specify { @today.should_not == @tomorrow }
    end

    context 'tomorrow' do
      specify { @tomorrow.should_not == @today }
      specify { @tomorrow.should == @always }
      specify { @tomorrow.should_not == @never }
      specify { @tomorrow.should == @tomorrow }
    end

    context 'always' do
      specify { @always.should == @today }
      specify { @always.should == @always }
      specify { @always.should == @tomorrow }
      it "should throw an error" do
        expect { @always == @never }.to raise_error Spree::DateTime::CausalityConflict
      end
    end

    context 'never' do
      specify { @never.should_not == @today }
      specify { @never.should_not == @never }
      specify { @never.should_not == @tomorrow }
      it "should throw an error" do
        expect { @never == @always }.to raise_error Spree::DateTime::CausalityConflict
      end
    end
  end
end