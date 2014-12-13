require 'rubygems'
require 'puppet-lint/tasks/puppet-lint'
require 'puppetlabs_spec_helper/rake_tasks'
require 'hiera'
require 'rake'
require 'rake/tasklib'
require 'puppet-lint'

PuppetLint.configuration.fail_on_warnings = true
# Disable puppet-lint rules we don't want to enforce right now
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_documentation')
# There is a problem with the class_parameter_defaults rule and it will be removed in the future
# See https://github.com/rodjek/puppet-lint/pull/167
PuppetLint.configuration.send('disable_class_parameter_defaults')
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp", "test/**/*.pp", ".vendor/**/*.pp"]

exclude_paths = [
  "pkg/**/*",
  ".bundle/**/*",
  "spec/**/*",
]
PuppetLint.configuration.ignore_paths = exclude_paths
PuppetSyntax.exclude_paths = exclude_paths


task :default => [:all]

desc "runs all tests"
task :all => [:validate, :spec, :lint, :beaker]

desc "for 'ci' / shims directory, and for guard tests" #validate seems to change files causing perpetual guard runs
task :cibuild => [:validate, :spec, :lint] #validate expected to call syntax.

desc "for guard acceptance and tests"
task :test_and_beaker => [:test,:beaker_prov]

### Tasks to speed up beaker testing.
desc "Show fast beaker workflow help"
task :beaker_help do
   help = <<-EOS
Speed up your beaker workflow by these commands:
  \e[34m`rake beaker_prov`\e[0m
      -> uses .spec/acceptance/nodsets/default.yml
      -> like `rake beaker` but won't destroy the vm.
          - run this again to re-provision and test.
  \e[34m`rake beaker_testonly`\e[0m
      -> requires `beaker_prov` first. Only runs tests.
      -> ... FAST!
      EOS
  puts help
end

desc "Start beaker - without destroying"
task :beaker_prov do
  ENV['BEAKER_destroy'] = 'no'
  ENV['BEAKER_provision'] = ''
  Rake::Task["beaker"].execute
end

desc "Start beaker - only run tests"
task :beaker_testonly do
  ENV['BEAKER_destroy'] = 'no'
  ENV['BEAKER_provision'] = 'no'
  Rake::Task["beaker"].execute
end

desc "runs vagrant destroy (with one last test)"
task :beaker_destroy do
  ENV['BEAKER_destroy'] = ''
  ENV['BEAKER_provision'] = 'no'
  Rake::Task["beaker"].execute
end
### End Tasks to speed up beaker testing.

