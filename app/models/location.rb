# frozen_string_literal: true

class Location < ApplicationRecord
  has_and_belongs_to_many :staffs # rubocop:todo Rails/HasAndBelongsToMany
  has_many :inventory_items # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :ingredients, through: :inventory_items
  has_many :deliveries # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :wastes # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :menus # rubocop:todo Rails/HasManyOrHasOneDependent
  has_many :sales, through: :menus

  def self.current(config = Rails.configuration.x.location)
    Location.find_by!(name: config.name)
  rescue ActiveRecord::RecordNotFound
    raise DefaultLocationNotFound
  end
end
