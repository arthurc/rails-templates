gem "inherited_resources"
gem "formtastic"
gem "haml"
gem "sass"
gem "rails3-generators", :group => :development
gem "rspec", :group => :test
gem "rspec-rails", :group => :test
gem "haml-rails"
gem "jquery-rails"
gem "factory_girl_rails", :group => :test
gem "shoulda", :group => :test
gem "cucumber", :group => :test
gem "cucumber-rails", :group => :test
gem "database_cleaner", :group => :test
gem "capybara", :group => :test

run "bundle"
run "rm public/javascripts/rails.js"

generate "formtastic:install"
generate "jquery:install"
generate "cucumber:install", "--capybara", "--rspec"

application <<-END
  config.time_zone = 'Stockholm'
  
  config.generators do |g|
    g.stylesheets false
    g.test_framework :rspec
    g.fixture_replacement :factory_girl
  end
END

file "lib/templates/rails/controller/controller.rb", <<-END
class <%= class_name %>Controller < InheritedResources::Base
end
END
