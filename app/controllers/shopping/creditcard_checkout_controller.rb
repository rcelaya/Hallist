class Shopping::CreditcardCheckoutController < Shopping::BaseController

  include Shopping::CreditcardCheckoutHelper
  def pay
    @name = params[:first_name] +' '+ params[:last_name]
    @order = find_or_create_order
    puts 'order total' + to_cents(@order.total).to_yaml
    Conekta.api_key= "key_FfrkmqPQodQdPFEQ"
    charge = Conekta::Charge.create({
                                         "amount" => to_cents(@order.total),
                                         "currency" => 'USD',
                                         "description" => 'Waldos',
                                         "card" => {
                                             "name" => @name,
                                             "cvc" => params[:verification_value],
                                             "exp_month" => params[:month],
                                             "exp_year" => params[:year],
                                             "number" => params[:number],
                                             "address" => {
                                                 "street1" => 'Alfonso Reyes 231',
                                                 "street2" => 'Despacho 112',
                                                 "street3" => 'Condesa',
                                                 "city" => 'Cuauhtemoc',
                                                 "state" => 'DF',
                                                 "country" => 'MX',
                                                 "zip" => '06100'
                                             }
                                         }
                                     })

    puts 'cargo tarjeta' + charge.to_yaml.as_json
    if charge.status = 'paid'
      puts 'entro a el cargo'
      @order.remove_user_store_credits
      session_cart.mark_items_purchased(@order)
      redirect_to root_url
    else
      notice = "Woops. Something went wrong while we were trying to complete the purchase with Paypal. Btw, here's what Paypal said: #{purchase.message}"
      redirect_to checkout_shopping_order_path, :notice => notice
    end
  end
end
