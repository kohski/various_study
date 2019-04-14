require 'active_record'
require 'pp'

# Time.zone_default = Time.find_zone! 'Tokyo'
# ActiveRecord::Base.default_timezone = :local

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./myapp.db"
)

class User < ActiveRecord::Base
  has_many :comments, dependent: :destroy
end

class Comment < ActiveRecord::Base
  belongs_to :user
end

User.delete_all

User.create(name: "tanaka",age: 25)
User.create(name: "kimura",age: 19)
User.create(name: "takahashi",age: 40)
User.create(name: "mori",age: 12)
User.create(name: "tashiro",age: 34)


Comment.delete_all

Comment.create(user_id: 1, body: "hello_1")
Comment.create(user_id: 1, body: "hello_2")
Comment.create(user_id: 2, body: "hello_3")

user = User.includes(:comments).find(1)
pp user.comments

user.comments.each do |c|
  puts "#{user.name}: #{c.body}"
end

comments = Comment.includes(:user).all
comments.each do |c|
  puts "#{c.body} by #{c.user.name}"
end

User.find(1).destroy
pp Comment.all