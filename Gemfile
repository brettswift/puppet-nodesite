source 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
    gem 'puppet', puppetversion, :require => false
else
    gem 'puppet', :require => false
end

group  :development, :test do
  gem "rake",                    :require => false
  gem "puppet-lint",             :require => false
  gem "rspec-puppet",            :git => 'https://github.com/rodjek/rspec-puppet.git',
                                 :require => false
  gem "puppet-syntax",           :require => false
  gem "puppetlabs_spec_helper",  :require => false
  gem 'mocha', '1.0',            :require => false #1.1 causes problems.  Removing this dependency releases mocha to 1.1, which can happen eventually
  gem "beaker",                  :require => false
  gem "beaker-rspec",            :require => false
  gem "vagrant-wrapper",         :require => false
  gem "guard-rake",              :require => false
  gem "growl",                   :require => false
end