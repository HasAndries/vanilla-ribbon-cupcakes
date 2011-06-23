require 'sinatra/base'

module Resource
  class Update < Sinatra::Base
    post '/update' do
      dir = File.expand_path(File.join(File.dirname(__FILE__), "../.."))
      system "cd #{dir}; sudo git reset --hard; sudo git pull; sudo touch tmp/restart.txt"
      system "cd #{dir}; bundle; sudo gem clean"
      "Site Updated"
    end
  end
end