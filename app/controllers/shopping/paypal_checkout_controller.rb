class Shopping::PaypalCheckoutController < Shopping::BaseController
  
  include Shopping::PaypalCheckoutHelper
  
  def create
    @order = find_or_create_order
    @order.find_total
    setup_response = ::GATEWAY.setup_purchase(to_cents(@order.total), get_setup_purchase_params(request)) 
    redirect_to ::GATEWAY.redirect_url_for(setup_response.token)
  end
  
  def review
    if params[:token].nil? or params[:PayerID].nil?
      redirect_to root_url, :notice => "Sorry! Something went wrong with the Paypal purchase. Please try again later." 
    end
    
    @order = find_or_create_order
    @order.find_total

    purchase_params = get_purchase_params request, params
    purchase = ::GATEWAY.purchase to_cents(@order.total), purchase_params

    if purchase.success?
      @order.create_paypal_invoice(purchase, @order.credited_total)
      @order.remove_user_store_credits
      session_cart.mark_items_purchased(@order)
      Notifier.order_confirmation(@order, invoice).deliver rescue puts( 'do nothing...  dont blow up over an email')
      # OrderMailer.order_confirmation(@order).deliver
      redirect_to myaccount_order_path(@order)
    else
      notice = "Woops. Something went wrong while we were trying to complete the purchase with Paypal. Btw, here's what Paypal said: #{purchase.message}"
      redirect_to root_url, :notice => notice
    end
  end
  
end