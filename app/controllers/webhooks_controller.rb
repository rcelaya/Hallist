class WebhooksController < ApplicationController
# En Rails 4 suprime el mensaje: "WARNING: Can't verify CSRF token authenticity" añadiendo:
  skip_before_filter
  protect_from_forgery :except => :receptor
  require 'json'
  require 'yajl/json_gem'

  def receptor
    request.body.rewind  # in case someone already read it
    event_json = JSON.parse(request.body.read)
    puts event_json.as_json.to_yaml + 'webhokss'

    puts event_json['data']['object']['reference_id'].to_yaml + ' refenrence_id'
    reference_id = event_json['data']['object']['reference_id'].to_i
    description = event_json['data']['object']['description']
    amount = event_json['data']['object']['amount'].to_i
    currency = event_json['data']['object']['currency']

    puts reference_id.to_yaml
    puts description.to_yaml
    puts amount.to_yaml
    puts currency.to_yaml

    @order =  Order.find_by_number(reference_id).to_yaml + 'encontre la orden'
    puts @order.to_yaml
    if data['status'] == 'paid'
      Notifier.order_confirmation(@order, nil, reference_id, description, amount, currency).deliver
      render "shopping/checkout/pay_credit"

    end
    msg = { :status => "200"}
    render json: msg
  end
end