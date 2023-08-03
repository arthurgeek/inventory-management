# frozen_string_literal: true

module CurrentLocation
  extend ActiveSupport::Concern

  included do
    before_action :current_location
    helper_method :current_location
  end

  private

  def current_location
    Current.location ||= Location.current
  end
end
