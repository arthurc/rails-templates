git :init

run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"
run "cp config/database.yml config/example_database.yml"

file ".gitignore", <<-END
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END
 
git :add => ".", :commit => "-m 'initial commit'"

plugin "restful_authentication", :git => "git://github.com/technoweenie/restful-authentication.git"

generate(:authenticated, "user", "sessions")

rake "db:migrate"

git :commit => "-a -m 'added authentication'"

gem "haml"

run "haml --rails ."

git :commit => "-a -m 'added haml'"

# gem 'mislav-will_paginate', :lib => 'will_paginate',  :source => 'http://gems.github.com'

# git :commit => "-a -m 'added will_paginate'"

rake "rails:freeze:gems"
rake "gems:install"
rake "gems:unpack:dependencies"

git :commit => "-a -m 'froze gems'"
