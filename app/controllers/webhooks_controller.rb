class WebhooksController < ApplicationController
# En Rails 4 suprime el mensaje: "WARNING: Can't verify CSRF token authenticity" añadiendo:
  skip_before_filter
  protect_from_forgery :except => :receptor
  require 'json'
  require 'yajl/json_gem'

  def receptor
    request.body.rewind  # in case someone already read it
    event_json = JSON.parse(request.body.read)

    reference_id = event_json['data']['object']['reference_id']
    description = event_json['data']['object']['description']
    amount = event_json['data']['object']['amount'].to_i
    amount = number_to_currency amount
    currency = event_json['data']['object']['currency']
    @order =  Order.find_by_number(reference_id)

    if event_json['data']['object']['status'] == 'paid'
      @order.create_conekta_invoice(nil, @order.credited_total)
      Notifier.order_complete(@order, reference_id, description, amount, currency).deliver
    end
    Notifier.order_complete(@order, reference_id, description, amount, currency).deliver
    msg = { :status => "200"}
    render json: msg
  end
end