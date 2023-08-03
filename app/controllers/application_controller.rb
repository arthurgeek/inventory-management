# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include CurrentLocation

  rescue_from DefaultLocationNotFound, with: :default_location_not_found

  private

  def default_location_not_found
    render 'default_location_not_found', status: :not_found
  end
end
