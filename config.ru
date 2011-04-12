require 'colored'

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__)))
require 'lib/settings'
require 'lib/resources'

extend Colored if Settings::debug?

puts "****************************"
puts "ENVIRONMENT :: #{ENV['RACK_ENV']}"
puts "DEBUG MODE  :: " + (Settings::debug? ? "ACTIVE".red.bold : "INACTIVE".green.bold)
puts "****************************"

ENV['ROOT'] = File.dirname(__FILE__)
app = Rack::Builder.new {
  use Rack::CommonLogger
  use Rack::ShowExceptions

  map "/" do run Resource::Main.new end
  map "/product" do run Resource::Product.new end
}

run app