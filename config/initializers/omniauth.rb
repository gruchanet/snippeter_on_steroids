# Omni configuration
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, '521bd1e25068f277dd9d', '96ba75f8c4c8a75dfae1c455a32f7015a07fd84c', scope: 'user';
end