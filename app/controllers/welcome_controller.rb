class WelcomeController < ApplicationController

  def index
    @featured_product = ProductDecorator.decorate(Product.featured)
    @recents_products = ProductDecorator.decorate(Product.most_recents)
  end
end
