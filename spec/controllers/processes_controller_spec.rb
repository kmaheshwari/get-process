require 'rails_helper'

RSpec.describe ProcessesController, type: :controller do

  before(:each) do
    @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(ENV['token'])
  end

  describe 'GET /processes' do
    it 'sends a list of processes' do
      get :index, format: :json
      json = JSON.parse(response.body)
      # test for the 200 status-code
      expect(response).to be_success
    end
  end

  describe "GET /process_detail/100" do
    it 'retrieves a specific process' do
      get :show, params: {id: "100"}
      # test for the 200 status-code
      expect(response).to be_success
    end

    it 'gives error message for invalid process id' do
      get :show, params: {id: "xyz"}
      json = JSON.parse(response.body)
      
      expect(json["success"]).to eq false
    end

    it 'gives message if process does not exist' do
      get :show, params: {id: "1"}
      json = JSON.parse(response.body)

      expect(json["success"]).to eq false
    end
  end
end
