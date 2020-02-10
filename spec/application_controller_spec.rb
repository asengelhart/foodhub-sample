require_relative "spec_helper"

def app
  ApplicationController
end

describe ApplicationController do
  it "redirects to the producers index" do
    get '/'
    expect(last_response.status).to eq(302)
  end

  it "displays a welcome message" do
    get '/producers'
    expect(last_response.body).to include("Food Hub")
  end
end