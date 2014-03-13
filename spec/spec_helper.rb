require 'rspec-puppet'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))
puppet_path = "/var/lib/peadmin/.puppet"

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules') + ":" + File.join(puppet_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests') + ":" + File.join(puppet_path, 'manifests')
end
