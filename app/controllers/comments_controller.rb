class CommentsController < ApplicationController
  
  def index
    product = Product.find params[:product_id]
    respond_to do |format|
      format.json { render json: product.comments.map(&:json_to_show) }
    end
  end
  
  def create
    comment = Comment.new(params[:comment])
    comment.author = current_user.user
    
    respond_to do |format|
      if comment.save
        format.json { render json: comment.json_to_show }
      else
        format.json { render json: comment.errors }
      end
    end
  end
end
