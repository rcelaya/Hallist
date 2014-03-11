if Rails.env.test?
  Gibbon::Export.api_key = "fake"
  Gibbon::Export.throws_exceptions = false
end
Gibbon::API.api_key = "35b67fc98e8508fca88e64c945f273cd"
Gibbon::API.timeout = 15
Gibbon::API.throws_exceptions = false
Rails.configuration.mailchimp = Gibbon::API.new