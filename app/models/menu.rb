# frozen_string_literal: true

class Menu < ApplicationRecord
  belongs_to :location
  belongs_to :recipe
end
