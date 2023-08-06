# frozen_string_literal: true

class InventoryController < ApplicationController
  before_action :authenticate_user!

  def index
    @inventory_items = current_location.inventory_items.includes(:ingredient).all
  end
end
