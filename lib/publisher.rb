module Publisher

  def publish(message_complete, url = nil)
    @message_complete = message_complete
    @url = url

    publish_to_twitter if profile.settings[:twitter_share]
    publish_to_facebook if profile.settings[:facebook_share]
  end

private

  def twitter_client
    @twitter ||= Twitter::Client.new(:oauth_token => twitter_authentication.token, :oauth_token_secret => twitter_authentication.secret)
  end
  
  def facebook_client
    @facebook ||= Koala::Facebook::API.new(facebook_authentication.token)
  end

  def bitly
    @bitly ||= Bitly.new(BITLY_CREDENTIALS[:username], BITLY_CREDENTIALS[:api_key])
  end
  
  def publish_to_facebook
    facebook_client.put_connections("me", "feed", message: message)
  end
  
  def publish_to_twitter
    twitter_client.update(message)
  end
  
  def short_url
    bitly.shorten(@url).short_url
  end
  
  def message
    @message = @message_complete[0,110] + '... ' + short_url
  end
end