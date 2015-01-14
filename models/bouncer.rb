require 'singleton'

class Bouncer
  
  include Singleton
  
  def verify_api_key(key)
    # For now, accepts any key given.
    raise UnauthorizedAttemptError.new('Unknown API key.') if key.nil?
  end
  
  class UnauthorizedAttemptError < StandardError; end
  
end