require 'rails_helper'

RSpec.describe Person, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  describe "- durring creation" do
    context "- valid creation" do
      
      before do
        @count = Person.count
        create :person
      end

      it "- should be created." do
        expect(Person.count).to eq(@count+1)
      end

      it "- should be valid." do
        expect(Person.last.valid?).to eq(true)
      end
    end 

    context "- default person details" do

      let(:person1) { create :person }
      let(:person2) { create :person }

      it '- should be initialize with relevant informations.' do
        [person1, person2].each do |person|
          expect(person.name).to include("Person")
          expect(person.address).to include("Address")
          expect(person.email).to include("person" && "@" && "gmail.com")
          expect(person.workmen).to be(true).or be(false)
          expect(person.customer).to be(true).or be(false)
          expect(person.telephone).to eq("1111 111 111")
          expect(person.user_name).to include("User")
          expect(person.password_digest).to eq("asdf")
        end 
      end
    end  
  end
end
