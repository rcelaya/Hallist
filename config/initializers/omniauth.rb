Rails.application.config.middleware.use OmniAuth::Builder do
    provider :twitter, '5vePK2iGAxhEyqDsyFrqpg', 'Rd9z1CSWuux3GYXgz14p2PAavnPaCaEP24Gl7UBIRA'
    provider :facebook, '207443096095083', '6b763af5f0b2a36213efb96c85a5afb5'
end
