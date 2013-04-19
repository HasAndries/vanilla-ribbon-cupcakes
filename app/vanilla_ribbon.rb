require 'sinatra/base'
require './app/redis_author'
require './app/resources/admin'
require './app/resources/update'

Sinatra::Base.register Sinatra::Auth
Sinatra::Base.set :author, RedisAuthor.new

class VanillaRibbon < Sinatra::Base
  private
  class << self
    def concat_files(dir, filenames)
      content = ''
      dir = File.join(File.dirname(__FILE__), dir)
      filenames.each do |filename|
        File.open(dir+filename, 'r') do |file|
          content << file.read
        end
      end
      content
    end
  end

  public

  get '/' do
    redirect 'http://www.thecupcakegarden.co.za/'
  end
  get // do
    redirect 'http://www.thecupcakegarden.co.za/'
  end

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

  get '/js/complete.js' do
    content_type 'application/javascript', :charset => 'utf-8'
    VanillaRibbon.concat_files "../public/js/", ['jquery/jquery-1.6.1.min.js',
                                                 'jquery/jquery.nivo.slider.pack.js',
                                                 'google.js',
                                                 'main.js']
  end

  get '/css/complete.css' do
    content_type 'text/css', :charset => 'utf-8'
    VanillaRibbon.concat_files "../public/css/", ['reset.css',
                                                  'taf-seafarer-m.css',
                                                  'layout.css',
                                                  'nivo-slider.css']
  end
end