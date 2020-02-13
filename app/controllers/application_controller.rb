require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, SecureRandom.hex(64)
  end

  get "/" do
    redirect '/producers'
  end

  helpers do
    def pop_session_errors
      e = session[:errors]
      session[:errors] = nil
      e
    end
  end
end
