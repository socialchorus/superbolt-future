require 'spec_helper'

describe Superbolt::Future::Messenger, 'extensions' do
  let(:messenger) {
    Superbolt::Future::Messenger.new
  }

  let(:time) { Time.now + 20 }

  before do
    Superbolt.env = 'staging'
  end

  after do
    Superbolt::Queue.new('advocato_staging.future').clear
    Superbolt::Queue.new('advocato_staging').clear
  end

  context 'scheduling in future' do
    describe '#future!' do
      it "will send it to the future queue" do
        messenger.to('advocato').future!(time)
        Superbolt::Queue.new('advocato_staging.future').size.should == 1
      end

      it "will send along data if it gets any" do
        messenger.to('advocato').future!(time, {hello: 'world'})
        messenger.data.should == {hello: 'world'}
      end

      it "will not override data if it exists" do
        messenger.to('advocato').data({what: 'is up?'}).future!(time)
        messenger.data.should == { what: 'is up?'}
      end

      it "adds a key to the message about the desired future time" do
        messenger.to('advocato').future!(time)
        messenger.message[:future].should == time
      end
    end

    describe '#future' do
      it "won't send it immediately" do
        messenger.to('advocato').future(time)
        Superbolt::Queue.new('advocato_staging.future').size == 0
        Superbolt::Queue.new('advocato_staging').size == 0
      end

      it "will send it to the right queue once used" do
        messenger.to('advocato').future(time).send!({hello: 'Deepti!'})
        Superbolt::Queue.new('advocato_staging.future').size == 1
      end

      it "adds a key to the message about the desired future time" do
        messenger.to('advocato').future(time)
        messenger.message[:future].should == time
      end
    end
  end

  describe 'normal usage' do
    it "will send it to the normal queue" do
      messenger.to('advocato').send!
      Superbolt::Queue.new('advocato_staging').size.should == 1
    end
  end
end