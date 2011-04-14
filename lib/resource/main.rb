require 'sinatra/base'
require './lib/resource/admin'
require './lib/resource/product'

module Resource
  class Main < Sinatra::Base
    use Resource::Admin 
    use Resource::Product

    post '/update_site' do
      dir = File.expand_path(File.join(File.dirname(__FILE__), "../.."))
      system "cd #{dir}; sudo git reset --hard; sudo git pull; sudo touch tmp/restart.txt"
      "Site Updated"
    end
  end
end