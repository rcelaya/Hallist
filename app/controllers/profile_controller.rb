class ProfileController < ApplicationController
  layout 'profile'

  def show
    if params[:artwork_type] == 'likes'
      @likeables = Like.find_all_by_liker_id(params[:id])

      @likes = []
      @likeables.each do |like|
        @likes.push(Product.find(like.likeable_id))
      end
      @likes = ProductDecorator.decorate(@likes).map(&:json_to_browse).to_json.html_safe
    end

    @user_profile = if params[:username].present?
      Profile.find_by_username params[:username]
    elsif params[:id].present?
      User.find(params[:id]).profile
    else
      current_user.profile
    end

    if @user_profile
      @user = UserDecorator.decorate(@user_profile.user)
      @products = @user.products_for_profile
      @collections = @user.sample_collections
    else
      raise ActiveRecord::RecordNotFound
    end
  end

end
