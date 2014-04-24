require "spec_helper"

describe Mailer do
  describe "update_prices" do
    let(:mail) { Mailer.update_prices }

    it "renders the headers" do
      mail.subject.should eq("Update prices")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
