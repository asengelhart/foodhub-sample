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
      producer.errors.to_a.each do |error|
        add_session_error(error)
      end
      erb :'producers/signup'
    end
  end

  get '/producers/login' do
    erb :'producers/login'
  end

  post '/producers/login' do
    producer = Producer.find_by(email: params[:producer][:email])
    if producer.nil?
      session[:errors] = ["Email address not found."]
      erb :'producers/login'
    elsif !producer.authenticate(params[:producer][:password])
      session[:errors] = ["Password is incorrect."]
      erb :'producers/login'
    else
      session[:id] = producer.id
      redirect '/producers'
    end
  end

  get '/producers/item/new' do
    erb :'producers/items_form'
  end

  post '/producers/item/new' do
    item_hash = params[:item]
    name = item_hash[:name]
    count = item_hash[:count].to_i
    price = item_hash[:price].to_f
    if count < 1 || price < 0
      add_session_error("Initial inventory cannot be less than one.") if count < 1
      add_session_error("Price cannot be less than 0.") if price < 0
      erb :'producers/items_form'
    else
      item = Item.create(name: name, count: count, price_in_cents: price * 100, producer_id: current_user.id)
      redirect '/producers'
    end
  end

  helpers do
    def current_user
      @current_user ||= Producer.find_by(id: session[:id])
    end
  end
end
