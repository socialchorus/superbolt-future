require 'spec_helper'

describe Superbolt, '.message' do
  it "should use our Future::Messenger" do
    Superbolt::Future::Messenger.should_receive(:new).and_return(double)
    Superbolt.message
  end
end