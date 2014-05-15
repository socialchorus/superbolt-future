module Superbolt
  module Future
    module SpecHelpers
      def messenger_class
        Superbolt::Future::Messenger
      end

      def superbolt_future(superbolt_message)
        superbolt_message.stub(:future!) do |time, args|
          superbolt_message.future(time)
          superbolt_message.data(args)
          superbolt_messages << superbolt_message
        end

        superbolt_message
      end

      def stub_superbolt_messenger
        Superbolt.stub(:message) do |args|
          superbolt_future(superbolt_message)
        end
      end
    end
  end
end
