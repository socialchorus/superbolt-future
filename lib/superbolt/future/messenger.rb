# This is an extension of the existing Superbolt Messenger class
module Superbolt
  module Future
    class Messenger < ::Superbolt::Messenger
      attr_accessor :in_future

      def future!(time, opts=nil)
        future(time)
        data(opts)
        queue.push(message)
      end

      def future(time)
        attr_chainer(:in_future, time)
      end

      def destination_name
        "#{super}#{future_suffix}"
      end

      def future_suffix
        in_future ? '.future' : ''
      end

      def message 
        hash = super
        hash.merge({future: in_future})
      end
    end
  end
end