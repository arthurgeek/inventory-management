# frozen_string_literal: true

class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @reports = [
      Reports::DeliveryCost.new(location: current_location),
      Reports::InventoryValue.new(location: current_location),
      Reports::SalesRevenue.new(location: current_location),
      Reports::WasteCost.new(location: current_location)
    ]
  end
end
