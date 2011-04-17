module Settings
  def self.env
    (ENV['RACK_ENV'] || 'test').to_sym
  end
  def self.debug?
    Settings::environment[:debug] && ENV['RACK_ENV'] != 'test'
  end

  def self.database(env = Settings.env)
    {
        :test =>        {:host => 'localhost', :port => 6379},
        :development => {:host => 'localhost', :port => 6379},
        :production =>  {:host => 'localhost', :port => 6379}
    }[env]
  end

  def self.environment(env = Settings.env)
    {
        :test =>        {:debug => true,  :expire_days => 28},
        :development => {:debug => true,  :expire_days => 28},
        :production =>  {:debug => false, :expire_days => 28},
    }[env]
  end
end