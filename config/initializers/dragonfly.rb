# AIRFIELD
# DragonFly Configuration

class AirfieldMediaConfigurationException < Exception; end

require "dragonfly"

app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails)

if Rails.env.production?

  # Check that the required environment variables have been set:
  if ENV["AWS_ACCESS_KEY"] && ENV["AWS_SECRET_KEY"] && ENV["AWS_S3_BUCKET"]
    Rails.logger.info "Dragonfly AWS/S3 configuration is intact."
  else
    Rails.logger.error "Dragonfly AWS/S3 cannot be configured. Set application configuration variables:"
    Rails.logger.error "  ENV['AWS_ACCESS_KEY'] => AWS Access Key"
    Rails.logger.error "  ENV['AWS_SECRET_KEY'] => AWS Secret Access Key"
    Rails.logger.error "  ENV['AWS_S3_BUCKET'] => Name of S3 Bucket"
    raise AirfieldMediaConfigurationException.new("Dragonfly AWS/S3 cannot be configured. Required environment variables not set.")
  end

  # Configure production application to use given S3 credentials:
  app.configure do |c|
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
      :bucket_name => ENV["AWS_S3_BUCKET"],
      :access_key_id => ENV["AWS_ACCESS_KEY"],
      :secret_access_key => ENV["AWS_SECRET_KEY"]
    )
  end

end # production?

app.define_macro(ActiveRecord::Base, :image_accessor)
