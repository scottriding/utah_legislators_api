require 'sinatra/base'
require 'sinatra/jsonp'
require './settings'
require_relative 'models/bouncer'
require_relative 'models/utah_address'
require_relative 'models/utah_legislature'

class UtahLegislatorsAPI < Sinatra::Base

  before do
    # Ensure access is authorized
    mickey = Bouncer.instance
    mickey.verify_api_key(params[:api_key]) 
  end
  
  ##### Basic API #####
  
  get '/house/:district' do
    rep = UtahLegislature::Representative.by_district(params[:district])
    JSONP rep.to_json
  end
  
  get %r{/house(/)?} do
    reps = UtahLegislature::Representative.all_districts
    JSONP reps.to_json
  end
  
  get '/senate/:district' do
    senator = UtahLegislature::Senator.by_district(params[:district])
    JSONP senator.to_json
  end
  
  get %r{/senate(/)?} do
    senators = UtahLegislature::Senator.all_districts
    JSONP senators.to_json
  end
  
  get '/representation' do
    reps = UtahLegislature::Representation.find(params[:address], params[:area])
    JSONP reps.to_json
  end
  
  ##### Exceptional Issues #####
  
  error Bouncer::UnauthorizedAttemptError do
    status 401
    error_message
  end
  
  error UtahAddress::ServiceError do
    status 503
    error_message
  end
  
  error UtahAddress::AddressError do
    status 400
    error_message
  end
  
  error UtahAddress::AreaError do
    status 400
    error_message
  end
  
  error UtahAddress::GeocodeError do
    status 404
    error_message
  end
  
  error UtahLegislature::Legislator::NonExistantDistrictError do
    status 400
    error_message
  end
  
  # Unanticipated errors
  error do
    status 500
    error_message
  end
  
  private
  
  def error_message
    {:error_message => env['sinatra.error'].message }
  end
  
end