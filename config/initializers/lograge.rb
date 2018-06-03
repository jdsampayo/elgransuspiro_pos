Rails.application.configure do
  config.lograge.enabled = Rails.env.production?
end
