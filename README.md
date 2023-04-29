
bundle install
rails db:create
rails db:migrate
rails db:seed
bin/setup

rails s

http://localhost:3000/users/sign_in
http://localhost:3000/users/edit
http://localhost:3000/admin/dashboard
