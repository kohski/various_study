require 'active_record'
require 'pp'
require 'logger'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./myapp.db"
)


class User < ActiveRecord::Base
end

user = User.new do |u|
  u.name = "mochizuki"
  u.age = 18
end

user.save