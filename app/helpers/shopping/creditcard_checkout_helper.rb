module Shopping::CreditcardCheckoutHelper
  def to_cents(money)
    (money*100).round
  end
end
