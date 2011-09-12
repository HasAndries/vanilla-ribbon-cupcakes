require 'sinatra/base'
require './app/redis_author'
require './app/resources/admin'
require './app/resources/update'

Sinatra::Base.register Sinatra::Auth
Sinatra::Base.set :author, RedisAuthor.new

class VanillaRibbon < Sinatra::Base
  use Resource::Admin
  use Resource::Update

  get '/?' do
    @title = ''
    @name = 'index'
    erb :index
  end

  get '/gallery/:id' do
    @name = 'gallery_full'
    @gallery = params[:id]
    @title = " - Gallery - #{@gallery.capitalize}"
    @dir = File.join(File.dirname(__FILE__), "../public/images/gallery/#{@gallery}")
    @images = []
    Dir.new(@dir).each do |filename|
      @images << filename unless filename =~ /\w*_thumb./ || filename.length < 5
    end
    @images.sort!
    erb :gallery_full
  end

  %w[gallery pricing contact about].each do |path|
      get "/#{path}/?" do
        @name = path
        @title = " - #{path.capitalize}"
        erb path.to_sym
      end
  end

  get '/css/complete.css' do
    content = ''
    dir = File.join(File.dirname(__FILE__), "../public/css/")
    filenames = ['reset.css', 'taf-seafarer-m.css', 'layout.css', 'nivo-slider.css']
    filenames.each do |filename|
      File.open(dir+filename, 'r') do |file|
        content << file.read
      end
    end
    content_type 'text/css', :charset => 'utf-8'
    content
  end
end