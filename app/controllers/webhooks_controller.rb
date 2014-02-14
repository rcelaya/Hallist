class WebhooksController < ApplicationController
  skip_before_filter
  protect_from_forgery :except => :receptor

  require 'json'
  require 'yajl/json_gem'

  def receptor
    event_json = JSON.parse(request.body.read)

    item = event_json['data']['object']['reference_id']
    reference_id = event_json['data']['object']['id']
    description = event_json['data']['object']['description']
    amount = event_json['data']['object']['amount'].to_i
    amount = (amount/100)
    currency = event_json['data']['object']['currency']
    @order =  Order.find_by_number(item)

    if event_json['data']['object']['status'] == 'paid'
      @order.create_conekta_invoice(nil, @order.credited_total)
      Notifier.order_complete(@order, reference_id, description, amount, currency).deliver
    end
    msg = { :status => "200"}
    render json: msg
  end
end