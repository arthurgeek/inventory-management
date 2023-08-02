# frozen_string_literal: true

class Location < ApplicationRecord
  has_and_belongs_to_many :staffs # rubocop:todo Rails/HasAndBelongsToMany
  has_many :inventory_items # rubocop:todo Rails/HasManyOrHasOneDependent
end
