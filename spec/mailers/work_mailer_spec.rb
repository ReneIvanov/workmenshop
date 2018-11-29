require "rails_helper"

RSpec.describe WorkMailer, type: :mailer do
  describe "created" do
    let(:email) { "rene.ivanov@gmail.com" }
    let(:mail) { WorkMailer.created(email) }

    it "renders the headers" do
      expect(mail.subject).to eq("Workmenshop - new work")
      expect(mail.to).to eq([email])
      expect(mail.from).to eq([Workmenshop::Application.credentials.dig(Rails.env.to_sym, :USERNAME)])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("New work has been created!")
    end
  end
end
