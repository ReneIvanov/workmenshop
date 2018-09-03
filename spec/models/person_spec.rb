require 'rails_helper'

RSpec.describe Person, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  it do
  	expect(1+200).to eq(201)
  end

  describe 'default person details' do
    let(:person) { create :person }

    it 'should initialize person with name and user_name' do
      expect(person.name).to eq("Ezo")
    end
  end
=begin
  describe 'describe-2' do
    before do
      create :person
    end

    it 'example-3' do
      expect(Person.count).to eq 1

      w = Person.last

      expect(w.name).to eq("Ezo")
      expect(w.age).to eq("Ezinko")
    end
  end
=end


end
