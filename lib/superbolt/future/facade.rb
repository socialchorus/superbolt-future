module Superbolt
  def self.message(args={})
    Superbolt::Future::Messenger.new(args)
  end
end
