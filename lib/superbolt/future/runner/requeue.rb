module Superbolt
  module Future
    module Runner
      class Requeue < ::Superbolt::Runner::AckOne
        def subscribe
          queue.subscribe(ack: true, block: true) do |delivery_info, metadata, payload|
            message = Superbolt::IncomingMessage.new(delivery_info, payload, channel)
            process(message)
          end
        end

        def process(message)
          parsed_message = message.parse
          requeue(parsed_message)

          message.ack

          block.call(parsed_message, logger) if block
          sleep sleep_time
        rescue Exception => e
          on_error(message.parse, e)
        end

        def sleep_time
          0.5 # should this be dynamic?
        end

        def requeue(parsed_message)
          time = parsed_message["future"]
          q = if Time.parse(time) > Time.now
            logger.info("Requeueing message to #{time}")
            future_queue
          else
            logger.info("Sending message #{parsed_message} to worker queue")
            worker_queue
          end
          q.push(parsed_message)
        end

        def future_queue
          Superbolt::Queue.new(queue.name)
        end

        def worker_queue
          Superbolt::Queue.new(worker_queue_name)
        end

        def worker_queue_name
          queue.name.sub(/\.future$/, '')
        end
      end
    end
  end
end
