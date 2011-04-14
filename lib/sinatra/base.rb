#This puts before filter calls in-front of static files for security, might slow down requests
module Sinatra
  class Base
    private
    def dispatch!
      filter! :before
      static! if settings.static? && (request.get? || request.head?)
      route!
    rescue NotFound => boom
      handle_not_found!(boom)
    rescue ::Exception => boom
      handle_exception!(boom)
    ensure
      filter! :after unless env['sinatra.static_file']
    end
  end
end