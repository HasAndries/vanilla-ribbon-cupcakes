module Settings
  #==========================SETTINGS=============================
  def self.env
    (ENV['RACK_ENV'] || 'test').to_sym
  end
  def self.debug?
    Settings::server[:debug] && ENV['RACK_ENV'] != 'test'
  end
  #==========================DATABASE=============================
  def self.db(env = Settings.env)
      {
          :test =>        {:host => 'localhost', :port => 6379},
          :development => {:host => 'localhost', :port => 6379},
          :production =>  {:host => 'localhost', :port => 6379}
      }[env]
    end
  #==========================SERVER===============================
  def self.server(env = Settings.env)
    {
        :test =>        {:debug => true, :smtp => 'smtp.gmail.com'},
        :development => {:debug => true, :smtp => 'smtp.gmail.com'},
        :production =>  {:debug => true, :smtp => 'smtp.gmail.com'},
    }
  end
  #==========================EMAIL================================
  def self.email(env = Settings.env)
    {
        :test =>        {:support => 'me@topspeed.com'},
        :development => {:support => 'me@topspeed.com'},
        :production =>  {:support => 'coetzee.andries@gmail.com'}
    }[env]
  end
end