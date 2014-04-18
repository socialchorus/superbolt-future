module Superbolt
  module Future
    class App < ::Superbolt::App
      def name
        worker_name = super
        worker_name + ".future"
      end

      def runner_class
        Superbolt::Future::Runner::Requeue
      end
    end
  end
end