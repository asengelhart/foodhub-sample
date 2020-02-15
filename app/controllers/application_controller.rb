require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "TODO: replace with environment variable"
  end

  get "/" do
    redirect '/producers'
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  helpers do
    def add_session_error(message)
      session[:errors] = [] if session[:errors].nil?
      session[:errors] << message
    end
    
    def pop_session_errors
      e = session[:errors]
      session[:errors] = nil
      e
    end
  end
end
