# frozen_string_literal: true

require 'faker'

puts '🌱 Seeding database' # rubocop:disable Rails/Output

20.times do
  location = Location.create({ name: Faker::Restaurant.unique.name })

  10.times do
    location.staffs.create({ name: Faker::Name.unique.name })
  end
end

# Now, select some random Staff and add to other random locations
Staff.order('RANDOM()').limit(50).each do |staff|
  staff.locations << Location.where.not(
    locations: { id: staff.locations.pluck(:id) }
  ).order('RANDOM()').limit(rand(1..3))
end

puts '✅ Database seeded' # rubocop:disable Rails/Output
