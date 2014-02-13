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
    data = event_json['data']['object']

    @order.number = data.id.to_i
    @order.user.name = data.id.to_i
    @order.user.mail = data.description

    if data.status == 'paid'
      Notifier.order_confirmation(@order, nil, data.id, data.description, data.amount, data.currency).deliver
      render "shopping/checkout/pay_credit"

    end
    msg = { :status => "200"}
    render json: msg
  end
end