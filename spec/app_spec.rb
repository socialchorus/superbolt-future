require 'spec_helper'

describe Superbolt::App do 
  let(:app) {
    Superbolt::Future::App.new(name, {logger: logger})
  } 

  before do
    future_queue.clear
    worker_queue.clear
    Superbolt.env = env
  end

  after do
    future_queue.clear
    worker_queue.clear
  end

  let(:env)         { 'test' }
  let(:name)        { 'superbolt' }
  let(:logger)      { Logger.new('/dev/null') }

  let(:worker_queue) { Superbolt::Queue.new("#{name}_#{env}") }
  let(:future_queue) { Superbolt::Queue.new("#{name}_#{env}.future") }
  let(:quit_queue)   { Superbolt::Queue.new("#{name}_#{env}.future.quit") }

  context 'when the future message key is in the past' do
    let(:message) { 
      {
        origin: 'origin',
        event: 'do_something',
        arguments: {
          hello: 'developers'
        },
        future: Time.now - 3600
      }
    }

    it "moves the message from the future queue to the worker queue" do
      future_queue.push(message)
      
      app.run do |arguments|
        quit_queue.push({message: 'just because'})
      end

      worker_queue.size.should == 1
      future_queue.size.should == 0
    end
  end

  context 'when the time is in the future' do
    let(:message) { 
      {
        origin: 'origin',
        event: 'do_something',
        arguments: {
          hello: 'developers'
        },
        future: Time.now + 3600
      }
    }

    it "puts the message back on the future queue" do
      future_queue.push(message)
      
      app.run do |arguments|
        quit_queue.push({message: 'just because'})
      end

      worker_queue.size.should == 0
      future_queue.size.should > 1 # there is a race condition with the quit queue, everything async
    end
  end
end