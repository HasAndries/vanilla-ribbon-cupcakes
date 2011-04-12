require 'sinatra/base'

module Resource
  class Main < Sinatra::Base
    post '/update_site' do
      dir = File.expand_path(File.join(File.dirname(__FILE__), "../.."))
      system "cd #{dir}; git pull; touch tmp/restart.txt"
      "Site Updated"
    end
  end
end