require './config/environment'

class ProducersController < ApplicationController

  get '/producers' do
    erb :'producers/index'
  end

  get '/producers/signup' do
    erb :'producers/signup'
  end

  post '/producers/signup' do
    producer_info = params[:producer]
    producer = Producer.new(name: producer_info[:name], email: producer_info[:email], password: producer_info[:password])
    if producer.save
      session[:user_id] = producer.id
      redirect '/producers'
    else
      session[:errors] = producer.errors.to_a
      erb :'/producers/signup'
    end
  end

  helpers do
    def current_user
      @current_user ||= Producer.find_by(id: session[:id])
    end
  end
end
