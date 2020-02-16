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
    check_logged_in
    erb :'producers/items_form'
  end

  post '/producers/item/new' do
    check_logged_in
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

  get '/producers/item/:id/edit' do
    check_logged_in
    @item = Item.find_by(id: params[:id])
    check_item_ownership(@item)
    erb :'producers/items_form'
  end

  patch '/producers/item/:id/edit' do
    check_logged_in
    @item = Item.find_by(id: params[:id])
    check_item_ownership(@item)
    item_hash = params[:item]
    @item.name = item_hash[:name]
    @item.count = item_hash[:count].to_i
    @item.price_in_cents = item_hash[:price].to_f * 100
    if @item.save
      redirect '/producers'
    else
      @item.errors.to_a.each do |error|
        add_session_error(error)
      end
      erb :'producers/items_form'
    end
  end

  delete '/producers/item/:id/edit' do
    check_logged_in
    @item = Item.find_by(id: params[:id])
    check_item_ownership(@item)
    @item.delete
    redirect '/producers'
  end

  helpers do
    def current_user
      @current_user ||= Producer.find_by(id: session[:id])
    end

    def check_logged_in
      if current_user.nil?
        add_session_error("Must be logged in to perform this action.")
        redirect '/producers/login'
      end
    end

    def check_item_ownership(item)
      if item.nil?
        add_session_error("Item does not exist.")
        redirect '/producers'
      end
      if item.producer_id != current_user.id
        add_session_error("Item registered to another producer.")
        redirect '/producers'
      end
    end
  end
end
