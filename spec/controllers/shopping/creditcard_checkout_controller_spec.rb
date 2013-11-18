require 'spec_helper'

describe Shopping::CreditcardCheckoutController do

  describe "GET 'pay'" do
    it "returns http success" do
      get 'pay'
      response.should be_success
    end
  end

end
