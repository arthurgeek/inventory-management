# frozen_string_literal: true

class InventoryItem < ApplicationRecord
  belongs_to :location
  belongs_to :ingredient
end
