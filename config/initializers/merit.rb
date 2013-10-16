# Use this hook to configure merit parameters
Merit.setup do |config|
  # Check rules on each request or in background
  # config.checks_on_each_request = true

  # Define ORM. Could be :active_record (default) and :mongo_mapper and :mongoid
  # config.orm = :active_record

  # Define :user_model_name. This model will be used to grand badge if no :to option is given. Default is "User".
  # config.user_model_name = "User"

  # Define :current_user_method. Similar to previous option. It will be used to retrieve :user_model_name object if no :to option is given. Default is "current_#{user_model_name.downcase}".
  # config.current_user_method = "current_user"

end

Badge.create(id: 1, name: 'hello-word', image: 'badge-001.png')
Badge.create(id: 2, name: 'popular', image: 'badge-002.png')
Badge.create(id: 3, name: 'new-talent', image: 'badge-003.png')
Badge.create(id: 4, name: 'been-around', image: 'badge-004.png')
Badge.create(id: 5, name: 'on-my-way-to-the-top', image: 'badge-005.png')
Badge.create(id: 6, name: 'pop-icon', image: 'badge-001.png')
Badge.create(id: 7, name: 'good-luck-first-sale!', image: 'badge-002.png')
Badge.create(id: 8, name: 'new-kid-on-the-block', image: 'badge-003.png')
Badge.create(id: 9, name: 'rising-star', image: 'badge-004.png')
Badge.create(id: 10, name: 'gallery', image: 'badge-005.png')
Badge.create(id: 11, name: 'solo-show', image: 'badge-001.png')
Badge.create(id: 12, name: 'gallery-level', image: 'badge-002.png')
Badge.create(id: 13, name: 'rock-star', image: 'badge-003.png')
Badge.create(id: 14, name: 'friend-o', image: 'badge-004.png')
Badge.create(id: 15, name: 'promoter', image: 'badge-005.png')
Badge.create(id: 16, name: 'curator', image: 'badge-001.png')
Badge.create(id: 17, name: 'art-collector', image: 'badge-002.png')
Badge.create(id: 18, name: 'private-gallery', image: 'badge-003.png')
Badge.create(id: 19, name: 'high-roller', image: 'badge-004.png')


# Create application badges (uses https://github.com/norman/ambry)
# Badge.create!({
#   :id => 1,
#   :name => 'just-registered'
# })
