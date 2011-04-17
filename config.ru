require 'colored'

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), '..'))

require './app/settings'
require './app/vanilla_ribbon'

extend Colored if Settings::debug?
Sinatra::Base.set :public, File.dirname(__FILE__) + '/public'
Sinatra::Base.set :views, File.dirname(__FILE__) + '/views'

puts "****************************"
puts "ENVIRONMENT :: #{ENV['RACK_ENV']}"
puts "DEBUG MODE  :: " + (Settings::debug? ? "ACTIVE".red.bold : "INACTIVE".green.bold)
puts "PUBLIC DIR  :: #{Sinatra::Base.public}"
puts "VIEWS DIR   :: #{Sinatra::Base.views}"
puts "****************************"

ENV['ROOT'] = File.dirname(__FILE__)
def app
  Rack::Builder.new {
    use Rack::CommonLogger
    use Rack::ShowExceptions

    map "/" do run VanillaRibbon.new end
  }
end

run app