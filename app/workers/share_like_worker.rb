class ShareLikeWorker
  include Sidekiq::Worker

  def perform(user_id, artwork_id)
    user = User.find(user_id)
    artwork = Product.find(artwork_id)
    user.publish("I just like")
  end
end