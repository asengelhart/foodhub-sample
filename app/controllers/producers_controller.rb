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
      session[:id] = producer.id
      redirect '/producers'
    else
      session[:errors] = producer.errors.to_a
      erb :'/producers/signup'
    end
  end

  get '/producers/login' do
    erb :'producers/login'
  end

  post '/producers/login' do
    producer = Producer.find_by(email: params[:producer][:email])
    if producer.nil?
      session[:errors] = ["Email address not found."]
      erb :'/producers/login'
    elsif !producer.authenticate(params[:producer][:password])
      session[:errors] = ["Password is incorrect."]
      erb :'/producers/login'
    else
      session[:id] = producer.id
      redirect '/producers'
    end
  end

  helpers do
    def current_user
      @current_user ||= Producer.find_by(id: session[:id])
    end
  end
end
