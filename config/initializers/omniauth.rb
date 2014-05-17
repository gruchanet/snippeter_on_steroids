# Omni configuration
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '1cff9a18ce0b9e461260', '913f145e659456cda9aeb3f75813da670b06f55b', scope: "user:email";
end