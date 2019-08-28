require 'rails_helper'

RSpec.describe Users::SessionsController do 
  describe 'GET #new' do
    it 'sets username in cookies' do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      expect(ENV).to receive(:[]).with("COOKIES").and_return('fakecookies')
      get :new
      expect(response.cookies['username']).to eq('fakecookies')
    end
  end
end