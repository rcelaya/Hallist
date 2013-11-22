class Shopping::CreditcardCheckoutController < Shopping::BaseController

  include Shopping::PaypalCheckoutHelper
  def pay
    @name = params[:name]
    total = params[:total].to_f
    @order = find_or_create_order
    products = @order.id.to_s + ' - ' + @order.number.to_s + '  [' + params[:products] + ']'
    puts 'ordeennnn completaa' + @order.to_yaml + params[:products]
    Conekta.api_key= "key_FfrkmqPQodQdPFEQ"
    charge = Conekta::Charge.create({
                                         "amount" => to_cents(total),
                                         "currency" => 'USD',
                                         "description" => products,
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
      redirect_to root_url, notice: "Purchase was Successful."
    else
      notice = "Woops. Something went wrong while we were trying to complete the purchase with Paypal. Btw, here's what Paypal said: #{purchase.message}"
      redirect_to checkout_shopping_order_path, :notice => notice
    end
  end
end
