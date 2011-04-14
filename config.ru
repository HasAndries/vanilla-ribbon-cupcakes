require 'colored'

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__)))
require 'lib/settings'
require 'lib/resource/main'

extend Colored if Settings::debug?
Sinatra::Base.set :public, File.dirname(__FILE__) + '/public'

puts "****************************"
puts "ENVIRONMENT :: #{ENV['RACK_ENV']}"
puts "DEBUG MODE  :: " + (Settings::debug? ? "ACTIVE".red.bold : "INACTIVE".green.bold)
puts "PUBLIC DIR  :: #{Sinatra::Base.public}"
puts "****************************"

ENV['ROOT'] = File.dirname(__FILE__)
app = Rack::Builder.new {
  use Rack::CommonLogger
  use Rack::ShowExceptions

  map "/" do run Resource::Main.new end
}

run app