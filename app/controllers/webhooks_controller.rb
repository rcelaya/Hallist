class WebhooksController < ApplicationController
# En Rails 4 suprime el mensaje: "WARNING: Can't verify CSRF token authenticity" añadiendo:
  skip_before_filter
  protect_from_forgery :except => :receptor
  require 'json'
  require 'yajl/json_gem'

  def receptor
    # Recibe el objeto de la notificación en JSON
    #request.body.rewind
    #data_json = JSON.parse(request.body.read)
    request.body.rewind  # in case someone already read it
    data = JSON.parse(request.body.read)

    puts data.as_json.to_yaml + 'webhokss'
    # Haz algo con data_json, por ejemplo:
    # @payment = Payment.find_by_id(data_json['data']['object']['id'].to_i)
    # send_email_to_customer(@payment.user)
    msg = { :status => "200"}
    render json: msg
  end
end