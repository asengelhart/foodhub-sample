require_relative "spec_helper"

def app
  ApplicationController
end

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

    describe 'get /signup' do
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
        visit '/producers/signup'
        fill_in :'producer[name]', :with => "Johnny McTestface"
        fill_in :'producer[email]', :with => "johnny2@testejo.com"
        fill_in :'producer[password]', :with => "Password"
        click_button "Submit"
        expect(last_response.body).to match(/not available/i)

        visit '/producers/signup'
        fill_in :'producer[name]', :with => "Johnny McTestface Jr."
        fill_in :'producer[email]', :with => "johnny@testejo.com"
        fill_in :'producer[password]', :with => "Password"
        click_button "Submit"
        expect(last_response.body).to match(/not available/i)
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
        visit '/producers/login'
        fill_in :'producer[email]', :with => "johnny@testejo.com"
        fill_in :'producer[password]', :with => "Password"
        click_button "Submit"
        expect(current_user).to eq(User.find_by(email: "johnny@testejo.com"))
      end
    end
  end
end