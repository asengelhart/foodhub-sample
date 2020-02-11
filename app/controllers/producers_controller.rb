require './config/environment'

class ProducersController < ApplicationController

  get '/producers' do
    erb :'producers/index'
  end

  get '/producers/signup' do
    erb :'producers/signup'
  end

  helpers do
    def current_user
      Producer.find_by(id: session[:id])
    end
  end
end
