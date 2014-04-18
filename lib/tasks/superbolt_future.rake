# assumes an environment task that sets up your app environment
desc "spins up process that looks at future queue and moves to the right queue at the right time"
task :superbolt_future => :environment do
  Superbolt::Future::App.new(Superbolt.app_name).run do |message, logger|
    logger.info('.')
  end
end