git :init

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "cp config/database.yml config/database.dist.yml"
run "rm public/index.html"

# GIT ignore
file ".gitignore", <<-END
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

# Nifty generators
run("sudo gem install nifty-generators")
generate(:nifty_layout)

# HAML
if yes?("Install haml?")
  gem "haml" 
  run "haml --rails ."
end

# Authlogic
if yes?("Install authlogic?")
  gem "authlogic"
  
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
  
  if yes?("Generate user_session, user, role models and user_sessions authbasic components?")
    generate(:session, "user_session")
    generate(:nifty_scaffold, "user", "login:string email:string crypted_password:string password_salt:string persistence_token:string single_access_token:string show new edit")
    generate(:nifty_scaffold, "role", "name:string new edit")
    generate(:controller, "user_sessions")
    
    route "map.resource :user_session"
    
    file "app/models/user.rb", <<-END
    class User < ActiveRecord::Base
      acts_as_authentic

      attr_protected :password, :password_confirmation
    end
    END
  end
end

# Declarative authorization
gem "declarative_authorization" if yes?("Install declarative_authorization?")

# Formtastic
gem "formtastic" if yes?("Install formtastic?")

# Will paginate
gem 'will_paginate' if yes?("Install will_paginate?")

rake "gems:install", :sudo => true

# Pages
if yes?("Generate pages?")
  generate(:nifty_scaffold, "page", "title:string name:string content:text active:boolean show new edit")
  route 'map.root :controller => "pages", :action => "show", :id => "welcome"'
end

# Freeze Rails and gems
rake "rails:freeze:gems"
rake "gems:unpack"

rake "db:migrate"

git :commit => "-m 'initial commit'"
git :add => "."
