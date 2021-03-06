require_relative "spec_helper"
require 'pry'
# def app
#   ApplicationController
# end

describe ApplicationController do
  it "redirects to the producers index" do
    get '/'
    expect(last_response.status).to eq(302)
  end
end

describe ProducersController do
  context "user is not logged in" do
    describe 'get /producers' do

      it 'displays a title' do
        visit '/producers'
        expect(page.status_code).to eq(200)
        expect(page.body).to include('Food Hub')
      end

      it 'has links for logging in and signing up' do
        visit '/producers'
        expect(page.body).to include('Log In')
        expect(page.body).to include('Sign Up')
      end
    end

    describe 'get /producers/signup' do
      it 'displays a signup form' do
        visit '/producers/signup'
        expect(page).to have_selector('form')
        expect(page).to have_field(:'producer[name]')
        expect(page).to have_field(:'producer[email]')
        expect(page).to have_field(:'producer[password]')
        expect(page).to have_button("Submit")
      end

      it 'creates a new user on signup' do
        visit '/producers/signup'
        fill_in :'producer[name]', :with => "Johnny McTestface"
        fill_in :'producer[email]', :with => "johnny@testejo.com"
        fill_in :'producer[password]', :with => "Password"
        click_button "Submit"
        expect(Producer.find_by(name: "Johnny McTestface")).to be_truthy
        expect(Producer.find_by(email: "johnny@testejo.com")).to be_truthy
      end

      it 'does not allow duplicate names or email addresses' do
        if Producer.find_by(name: "Johnny McTestface").nil?
          Producer.create(name: "Johnny McTestface", email: "johnny@testejo.com", password: "Password")
        end
        
        visit '/producers/signup'
        fill_in :'producer[name]', :with => "Johnny McTestface"
        fill_in :'producer[email]', :with => "johnny2@testejo.com"
        fill_in :'producer[password]', :with => "Password"
        click_button "Submit"
        expect(page.body).to match(/already been taken/i)

        visit '/producers/signup'
        fill_in :'producer[name]', :with => "Johnny McTestface Jr."
        fill_in :'producer[email]', :with => "johnny@testejo.com"
        fill_in :'producer[password]', :with => "Password"
        click_button "Submit"
        expect(page.body).to match(/already been taken/i)
      end
    end

    describe 'get /login' do
      it 'displays a login form' do
        visit '/producers/login'
        expect(page).to have_selector('form')
        expect(page).to have_field(:'producer[email]')
        expect(page).to have_field(:'producer[password]')
      end

      it 'logs in the user on submit' do
        if Producer.find_by(name: "Johnny McTestface").nil?
          Producer.create(name: "Johnny McTestface", email: "johnny@testejo.com", password: "Password")
        end
        visit '/producers/login'
        fill_in :'producer[email]', :with => "johnny@testejo.com"
        fill_in :'producer[password]', :with => "Password"
        click_button "Submit"
        expect(page.body).to include("Johnny McTestface")
      end
    end

    describe 'get /producers/item/new' do
      it 'redirects to login screen' do
        visit '/producers/item/new'
        expect(page.body).to include("Must be logged in to perform this action.")
        expect(page.current_url).to include("login")
      end
    end

    describe 'get /producers/item/:id/edit' do
      it 'redirects to login screen' do
        producer = Producer.create(name: "Johnny McTestface", email: "johnny@testejo.com", password: "Password")
        item = Item.create(name: "Test", count: 1, price_in_cents: 100, producer_id: producer.id)
        visit "/producers/item/#{item.id}/edit"
        expect(page.body).to include("Must be logged in to perform this action.")
        expect(page.current_url).to include("login")
      end
    end
  end

  context "user is logged in" do
    before(:each) do
      @producer = Producer.create(name: "Johnny McTestface", email: "johnny@testejo.com", password: "Password")
      @item1 = Item.create(name: "Tomato Hash", count: 2, price_in_cents: 200, producer_id: @producer.id)
      @item2 = Item.create(name: "Potato Browns", count: 4, price_in_cents: 500, producer_id: @producer.id)
    end
    def sign_me_in
      visit '/producers/login'
      fill_in :'producer[email]', :with => "johnny@testejo.com"
      fill_in :'producer[password]', :with => "Password"
      click_button "Submit"
    end

    describe 'get /producers' do
      it 'displays username and items' do
        visit '/producers/login'
        fill_in :'producer[email]', :with => @producer.email
        fill_in :'producer[password]', :with => "Password"
        click_button "Submit"
        expect(page.body).to include(@producer.name)
        expect(page.body).to include(@item1.name)
        expect(page.body).to include(@item2.name)
        expect(page).to have_button("Create New Item")
      end

      it 'correctly displays item prices' do
        visit '/producers/login'
        fill_in :'producer[email]', :with => @producer.email
        fill_in :'producer[password]', :with => "Password"
        click_button "Submit"
        expect(page.body).to include("$2.00")
        expect(page.body).to include("$5.00")
      end
    end

    describe 'get /logout' do
      it 'logs the user out' do
        post '/producers/login', :'producer[email]' => @producer.email, :'producer[password]' => "Password"
        expect(session[:id]).to eq(@producer.id)
        get '/logout'
        expect(session[:id]).to be_nil
      end
    end
    
    describe 'get /producers/item/new' do
      it 'has a form for making a new item' do
        sign_me_in
        visit '/producers/item/new'
        expect(page).to have_field(:'item[name]')
        expect(page).to have_field(:'item[price]')
        expect(page).to have_field(:'item[count]')
      end

      it 'creates a new item on submission' do
        sign_me_in
        visit '/producers/item/new'
        fill_in :'item[name]', :with => "Bean Soup Mix Jar"
        fill_in :'item[price]', :with => "3.00"
        fill_in :'item[count]', :with => "11"
        click_button "Submit"
        expect(Item.find_by(name: "Bean Soup Mix Jar")).to be_truthy
        expect(Item.find_by(name: "Bean Soup Mix Jar").price_in_cents).to eq(300)
        expect(Item.find_by(name: "Bean Soup Mix Jar").count).to eq(11)
      end
    end

    describe 'get /producers/item/:id/edit' do
      it 'has a form for editing an item' do
        sign_me_in
        visit "/producers/item/#{@item1.id}/edit"
        expect(page.find_by_id('base_form')[:action]).to eq("/producers/item/#{@item1.id}/edit")
        expect(page.find_by_id('base_form')).to have_field(type: "hidden", name:"_method")
        expect(page.find_by_id('delete_button')).to have_field(type: "hidden", name:"_method")
        expect(page).to have_field(:'item[name]')
        expect(page).to have_field(:'item[price]')
        expect(page).to have_field(:'item[count]')
      end

      it "changes the item's fields upon submit" do
        sign_me_in
        visit "/producers/item/#{@item1.id}/edit"
        fill_in :'item[name]', :with => "Bean Soup Mix Jar"
        fill_in :'item[price]', :with => "3.00"
        fill_in :'item[count]', :with => "11"
        click_button "Submit"
        persisted_item = Item.find_by(id: @item1.id)
        expect(persisted_item.name).to eq("Bean Soup Mix Jar")
        expect(persisted_item.price_in_cents).to eq(300)
        expect(persisted_item.count).to eq(11)
      end

      it "prevents users from editing items that aren't theirs" do
        new_producer = Producer.create(name: "Not Johnny", email: "nj@testejo.com", password: "p")
        new_item = Item.create(name: "New Thing", count: 1, price_in_cents: 50, producer_id: new_producer.id)
        sign_me_in
        visit "/producers/item/#{new_item.id}/edit"
        expect(page.body).to include("Item registered to another producer.")
      end
    end

    describe 'delete /producers/item/:id/edit' do
      it "deletes an item" do
        sign_me_in
        visit "/producers/item/#{@item1.id}/edit"
        click_button "Delete Item"
        expect(Item.all).not_to include(@item1)
      end

      it "prevents a user from deleting items that aren't theirs" do
        new_producer = Producer.create(name: "Not Johnny", email: "nj@testejo.com", password: "p")
        new_item = Item.create(name: "New Thing", count: 1, price_in_cents: 50, producer_id: new_producer.id)
        post "/producers/login", :'producer[email]' => @producer.email, :'producer[password]' => "Password"
        delete "/producers/item/#{new_item.id}/edit"
        follow_redirect!
        expect(last_response.body).to include("Item registered to another producer.")
      end
    end
  end
end