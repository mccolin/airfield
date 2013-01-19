# AIRFIELD
# Gem dependencies

source "https://rubygems.org"

# Lock in rails version:
gem "rails", "3.2.8"

# Development dependencies:
group :development do
  gem "mysql2"
  gem "quiet_assets"
end

# Production dependencies:
group :production do
  gem "pg"
end

# Asset processing:
group :assets do
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
end

# App-level features:
gem "jquery-rails"
gem "activeadmin", "~> 0.5.1"
gem "sass-rails", "~> 3.2.3"
gem "doeskeyvalue", "~> 0.9.1"            # Pre-release, but live
gem "redcarpet", "~> 2.2.2"               # Markdown render support
gem "stringex", "~> 1.5.1"                # Sluggable URLs
gem "acts-as-taggable-on", "~> 2.3.3"     # Taxonomy
#gem "liquid", "~> 2.4.1"                  # Templating, Layout (bracketed)
#gem "radius", "~> 0.7.3"                  # Templating, Layout (XML-style)

gem "axtags", "~> 0.1.0"                  # Templating, Layout (XML-style, optimized API)
#gem "axtags", :path=>"/Users/colin/git/mccolin/axtags"

gem "font-awesome-rails", "~> 0.4.1"      # FontAwesome used by Hallo.js editor
gem "kaminari"                            # Pagination
gem "has_heartbeat", "~> 0.1.1"           # Heartbeat for uptime monitoring
gem "newrelic_rpm"                        # New Relic perf and uptime pinging
