require './config/environment'

class ProducersController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views/producers'
  end

  get '/producers' do
    erb :index
  end
end
