class Shopping::CreditcardCheckoutController < Shopping::BaseController
  include Shopping::PaypalCheckoutHelper

  layout 'no-responsive'


  def pay
    @name_user = current_user.first_name
    @name_email = current_user.email
    @name = params[:name]
    @total = params[:total].to_f
    @order = find_or_create_order
    @products = @order.id.to_s + ' - ' + @order.number.to_s + '  [' + params[:products] + ']'
    puts 'ordeennnn completaa' + @order.to_yaml
    Conekta.api_key= "key_zsg3aghr2UzptsuF"

    begin
      if params[:payment_method] != 'oxxo'
        charge = Conekta::Charge.create({
                                            "amount" => to_cents(@total),
                                            "currency" => 'USD',
                                            "description" => @products,
                                            "reference_id" => @order.number.to_s,
                                            "card" => {
                                                "name" => @name,
                                                "cvc" => params[:verification_value],
                                                "exp_month" => params[:month],
                                                "exp_year" => params[:year],
                                                "number" => params[:number],
                                                "address" => {
                                                    "street1" => params[:address_credit],
                                                    "city" => params[:city],
                                                    "state" => params[:state],
                                                    "country" => params[:country],
                                                    "zip" => params[:zip]
                                                }
                                            }
                                        })
      else
        charge = Conekta::Charge.create({
                                            "amount" => to_cents(@total),
                                            "currency" => 'USD',
                                            "description" => @products,
                                            "reference_id" => @order.number.to_s,
                                            "cash" => {
                                                "type" => "oxxo"
                                            },
                                            "details" => {
                                                "name" => "oswaldo",
                                                "email" => 'waldix86@gmail.com',
                                                "phone" => '551-389-9832'
                                            }
                                        })
      end
    rescue => e
      puts 'cargo tarjeta' + e.message.to_yaml.as_json
      redirect_to :controller => 'shopping/checkout', :action => 'show'
      flash[:notice] = e.message
    ensure
      puts 'esta biennn'
      puts 'cargo tarjeta' + charge.to_yaml.as_json

      @reference_id = charge.id
      @item_description = charge.description
      @item = charge.reference_id
      @item_purchased_date = Date.today.to_s.to_date

      if charge.status == 'paid'
        @shipping_address = Address.find_by_addressable_id(current_user)
        if @shipping_address.present?
          @shipping_address = Address.find_by_addressable_id(current_user)
          @shipping_address.update_attributes(
              :address_type_id => AddressType::SHIPPING_ID,
              :first_name => params[:ship_address_first_name],
              :last_name => params[:ship_address_last_name],
              :address1 => params[:ship_address_address1],
              :address2 => params[:ship_address_address2],
              :city => params[:ship_address_city],
              :country => params[:ship_address_country],
              :zip_code => params[:ship_address_zip_code]
          )
        else
          @shipping_address = current_user.addresses.new(params[:address])
          @shipping_address.address_type_id = AddressType::SHIPPING_ID
          @shipping_address.first_name = params[:ship_address_first_name]
          @shipping_address.last_name = params[:ship_address_last_name]
          @shipping_address.address1 = params[:ship_address_address1]
          @shipping_address.address2 = params[:ship_address_address2]
          @shipping_address.city = params[:ship_address_city]
          @shipping_address.country = params[:ship_address_country]
          @shipping_address.zip_code = params[:ship_address_zip_code]
          @shipping_address.default = true
          @shipping_address.billing_default = true
          @shipping_address.save
        end
        puts 'entro a el cargo'
        #@order.create_paypal_invoice(purchase, @order.credited_total)
        @order.remove_user_store_credits
        session_cart.mark_items_purchased(@order)

        #Notifier.order_confirmation(@order).deliver
        #redirect_to root_url, notice: "Purchase was Successful."
        render "shopping/checkout/pay_credit"
        flash[:notice] = "Purchase was Successful."
      elsif charge.status == 'pending_payment'
        print = charge.payment_method.values

        puts "oxxo_printtt" + print.to_yaml

        @date = @charge
        @expiry_date = print[0]
        @barcode = print[1]
        @barcode_url = print[2]

        puts "oxxooo_expiry_date" + @expiry_date.to_yaml
        puts "oxxooo_barcode" + @barcode.to_yaml
        puts "oxxooo_barcode_url" + @barcode_url.to_yaml

        #redirect_to payment_credit_path(:expiry_date => @expiry_date, :barcode => @barcode, :barcode_url => @barcode_url), notice: "Purchase was Successful."
        #render :partial => "shopping/checkout/pay_credit", :locals => {:expiry_date => @expiry_date}
        render "shopping/checkout/pay_credit"
      else
        redirect_to :controller => 'shopping/checkout', :action => 'show'
        flash[:notice] = charge.failure_message
      end
    end
  end
end
