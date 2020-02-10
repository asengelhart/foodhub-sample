require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    redirect '/producer'
  end

  get '/producers' do
    erb :'producers/index'
  end
end
