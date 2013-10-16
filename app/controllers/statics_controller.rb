class StaticsController < ApplicationController

	layout 'no-responsive'

  def about
  end

  def privacy
  end

  def terms
  end

  def contact
  end

  def send_inquiry
    ContactUsMailer.new_inquiry(params[:email], params[:name], params[:message]).deliver
    redirect_to contact_path, notice: "Thanks for getting in touch. We'll get back to you shortly."
  end

end
