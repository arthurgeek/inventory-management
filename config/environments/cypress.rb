# frozen_string_literal: true

# Based on test environment
require Rails.root.join('config/environments/test')

Rails.application.configure do
  config.cache_classes = false
  config.action_view.cache_template_loading = false
  config.action_controller.allow_forgery_protection = true
end
