module Shopping::PaypalCheckoutHelper
  def get_setup_purchase_params(request)
    return {
        :ip => request.remote_ip,
        :return_url => review_shopping_paypal_checkout_url,
        :cancel_return_url => root_url,
        :subtotal => to_cents(@order.sub_total),
        :shipping => to_cents(@order.shipping_charges),
        :handling => 0,
        :tax =>      0,
        :allow_note =>  true,
        :items => get_items,
        :solution_type => 'sole',
        :currency => 'USD'
      }
  end

  def get_items
    @order.order_items.group_by(&:variant_id).collect do |variant_id, items|
      product = items.first.variant.product
      {:name => product.name, 
       :quantity => items.size, 
       :amount => to_cents(items.first.price), 
      }
    end
  end

  def to_cents(money)
    (money*100).round
  end
  
  def get_purchase_params(request, params)
    return {
      :ip => request.remote_ip,
      :token => params[:token],
      :payer_id => params[:PayerID],
      :subtotal => to_cents(@order.sub_total),
      :shipping => to_cents(@order.shipping_charges),
      :handling => 0,
      :tax =>      0,
      :items =>    get_items,
      :solution_type => 'sole',
      :currency => 'USD'
    }
  end
end
