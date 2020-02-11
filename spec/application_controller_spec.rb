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
        visit '/signup'
        expect(page).to have_selector('form')
        expect(page).to have_field(:name)
        expect(page).to have_field(:email)
        expect(page).to have_field(:password)
      end
    end
  end
  
end