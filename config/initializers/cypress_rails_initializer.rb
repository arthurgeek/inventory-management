# frozen_string_literal: true

return unless Rails.env.cypress?

Rails.application.load_tasks unless defined?(Rake::Task)

CypressRails.hooks.before_server_start do
  # Drop database
  Rake::Task['db:drop'].invoke

  # Create database
  Rake::Task['db:prepare'].invoke

  # Load some default data
  fixtures_dir = '../../cypress/fixtures/default'
  fixtures_files = 'locations,staffs'

  ENV['FIXTURES_DIR'] = fixtures_dir
  ENV['FIXTURES'] = fixtures_files

  Rake::Task['db:fixtures:load'].invoke
end

# CypressRails.hooks.after_server_start do
# end

# CypressRails.hooks.after_transaction_start do
# end

# CypressRails.hooks.after_state_reset do
# end

# CypressRails.hooks.before_server_stop do
# end
