# frozen_string_literal: true

class CreateJoinTableStaffsLocations < ActiveRecord::Migration[7.0]
  def change
    create_join_table :staffs, :locations do |t|
      t.index %i[staff_id location_id]
      t.index %i[location_id staff_id]
    end
  end
end
