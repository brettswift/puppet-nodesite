#Guard runs continuous tests, triggered when you save a file.
#simply run `guard` to have your tests run continuously so you don't have
#to alt-tab and run tests all the time.

guard 'rake', :task => 'test' do
  watch(%r{^spec\/(?!fixtures|acceptance)(.+)_spec.rb})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

#run with `guard -g beaker`
#note:  this does run a little slower it seems.
group :beaker do
  guard 'rake', :task => 'beaker_testonly' do
    watch(%r{^spec\/(?!fixtures)(.+)_spec.rb})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec" }
  end

end