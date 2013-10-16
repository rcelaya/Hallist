class Shopping::CheckoutController < Shopping::BaseController
  layout 'profile'
  
  require 'active_merchant/billing/integrations/action_view_helper'

  ActionView::Base.send(:include, ActiveMerchant::Billing::Integrations::ActionViewHelper)
  
  before_filter :user_exists?
  
  def show
    
    @order = find_or_create_order
    if @order.bill_address.blank? || @order.bill_address.first_name.blank?
      if current_user.default_billing_address
        @order.bill_address = current_user.default_billing_address
      else
        @order.build_bill_address
      end
    end
    
    if @order.build_ship_address.blank? || @order.build_ship_address.first_name.blank?
      if current_user.default_shipping_address
        @order.ship_address = current_user.default_shipping_address
      else
        @order.build_ship_address
      end
    end
    @order.default_shipping_rate
    @order.find_total
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new
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
end
