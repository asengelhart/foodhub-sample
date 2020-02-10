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
  it 'displays a title' do
    get '/producers'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include('Food Hub')
  end
end