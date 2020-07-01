require "bundler/setup"
require "image/tileify"
require 'fileutils'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.after(:suite) do
    FileUtils.rm_rf('./test_tiles')
  end
end

# custom rspec matcher to check if provided path is a directory
RSpec::Matchers.define :be_a_directory do
  match do |dir_path|
    Dir.exist?(dir_path)
  end
end

# custom rspec matcher for file existence
RSpec::Matchers.define :exists do
  match do |file_path|
    File.exist?(file_path)
  end
end