source 'https://rubygems.org'

# Puppet gem same version as in collection:
# https://docs.puppet.com/puppet/latest/reference/about_agent.html
gem 'puppet', '~> 5' # puppet-agent 5
gem 'puppet-lint'
gem 'puppetlabs_spec_helper'
gem 'rake'
gem 'librarian-puppet'
gem 'deep_merge'

if ENV.key?('PACKAGING') && ENV['PACKAGING'] == "fpm"
  gem 'fpm'
end
