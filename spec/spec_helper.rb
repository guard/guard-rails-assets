require 'nenv'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # TODO: reenable
    # expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # TODO: reenable
    # mocks.verify_partial_doubles = true
  end

  config.filter_run focus: !Nenv.ci?
  config.run_all_when_everything_filtered = true

  # TODO: reenable
  # config.disable_monkey_patching!

  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  # config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end
