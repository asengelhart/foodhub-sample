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
      before do
        get '/producers'
        @response = last_response
      end

      it 'displays a title' do
        expect(@response.status).to eq(200)
        expect(@response.body).to include('Food Hub')
      end

      it 'has links for logging in and signing up' do
        expect(@response.body).to include('Log In')
        expect(@response.body).to include('Sign Up')
      end
    end

    describe 'get /signup' do
      it 'displays a signup form' do
        visit '/signup'
        expect(page).to have_selector('form')
        expect(page).to have_field(:name)
        expect(page).to have_field(:email)
        expect(page).to have_field(:password)
      end
    end
  end
  
end