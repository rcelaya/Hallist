class Artwork::DashboardController < ApplicationController
  layout 'no-responsive'
  
  before_filter :login_required
  
  def show
    @products = ProductDecorator.decorate(current_user.brand.products)
  end
  
  private
  def login_required
    redirect_to login_url if current_user.user.blank?
  end
end
