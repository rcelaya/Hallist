class Shopping::CheckoutController < Shopping::BaseController
  #layout 'profile'
  layout 'no-responsive'
  
  require 'active_merchant/billing/integrations/action_view_helper'

  ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
  
  #before_filter :user_exists?
  
  def show
    user = current_user
    if !user.present?
      user = User.find(60)
    end
    @order = find_or_create_order
    if @order.bill_address.blank? || @order.bill_address.first_name.blank?
      if user.default_billing_address
        @order.bill_address = user.default_billing_address
      else
        @order.build_bill_address
      end
    end
    
    if @order.build_ship_address.blank? || @order.build_ship_address.first_name.blank?
      if user.default_shipping_address
        @order.ship_address = user.default_shipping_address
      else
        @order.build_ship_address
      end
    end
    @order.default_shipping_rate
    @order.find_total
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new

    puts 'checkout controller' + @order.to_yaml
    puts 'checkout controller + credit card' + @credit_card.to_yaml
  end
  
  def user_exists?
    redirect_to new_user_session_url if current_user.user.nil?
  end
  
  def twocheckout_return
    @order = find_or_create_order
    query_string = params.map {|param| "#{param[0]}=#{param[1]}"}.join('&')
    notification = ActiveMerchant::Billing::Integrations::TwoCheckout::Notification.new(query_string, options = {:credential2 => "arto"})

    if notification.complete? #&& notification.acknowledge
      @order.create_2checkout_invoice(notification, @order.credited_total)
      @order.remove_user_store_credits
      session_cart.mark_items_purchased(@order)
      Notifier.order_confirmation(@order, invoice).deliver rescue puts( 'do nothing...  dont blow up over an email')
      flash[:error] = I18n.t('the_order_purchased')
      redirect_to myaccount_order_url(@order)
    else
      redirect_to shopping_checkout_url, alert: 'Order Failed! MD5 Hash does not match!'
    end
  end

  def pay_credit
    puts 'este es el bueno ' + @expiry_date.to_yaml

  end
end
