git :init

FileUtils.touch(%w(tmp/.gitignore log/.gitignore vendor/.gitignore), :verbose => true)
FileUtils.copy("config/database.yml", "config/example_database.yml", :verbose => true)

# GIT ignore
file ".gitignore", <<-END
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

# Plugins
plugin "restful_authentication", :git => "git://github.com/technoweenie/restful-authentication.git"
plugin "declarative_authorization", :git => "git://github.com/stffn/declarative_authorization.git"
plugin 'will_paginate', :git => 'git://github.com/mislav/will_paginate.git', :submodule => true

# Gems
# gem "stffn-declarative_authorization", :lib => "declarative_authorization", :source => 'http://gems.github.com'
gem "haml"
rake "gems:install", :sudo => true

# Generate
generate(:authenticated, "user", "sessions")
generate(:model, "role", "name:string")

run "haml --rails ."

# Files
file "config/authorization_rules.rb", <<-END
authorization do
  # TODO
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end
END

file "db/migrate/20090129183012_initial_migration.rb", <<-END
class InitialMigration < ActiveRecord::Migration
  def self.up
    create_table "roles_users" do |t|
      t.references :role
      t.references :user
    end
  end
  
  def self.down
    drop_table "roles_users"
  end
end
END

git :submodule => "init"

# Freeze Rails and gems
freeze!

rake "db:migrate"

git :add => ".", :commit => "-m 'initial commit'"
