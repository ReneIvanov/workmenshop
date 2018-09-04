require 'rails_helper'

RSpec.describe PeopleController do
  describe 'index' do
    before do
      request.session[:admin] = true
      get :index
    end

    it do
      expect(response.status).to eq(200)
    end

    it do
      create :person, name: 'karol'
      expect(response.body).to match('<li>karol</li>')
      expect(response.body).to match('<li>jozo</li>')
    end
  end

  describe 'create' do
    before do
      post :create, params: { person: { name: "Ezo", address: "Kordiky" }}
    end

    it 'should be successful' do
      expect(response.status).to eq(200)
    end

    it 'should create a person' do
      expect(Person.last.name).to eq 'Ezo'
    end
  end
end

