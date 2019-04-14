require 'active_record'
require 'pp'

# Time.zone_default = Time.find_zone! 'Tokyo'
# ActiveRecord::Base.default_timezone = :local

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./myapp.db"
)

class User < ActiveRecord::Base
  # def self.top(num)
  #   select("id, name, age").order(:age).limit(num)
  # end
  # scopeの方があとあとチェーンメソッドを使えるので便利
  # scope :top, ->(num) { select("id, name, age").order(:age).limit(num) }
  # validates :name, :age, presence: true
  # validates :name, length: {minimum:3}
  before_destroy :print_before_msg
  after_destroy :print_after_msg

  protected
    def print_before_msg
      puts "#{self.name} will be deleted"
    end
    def print_after_msg
      puts "#{self.name} was deleted"
    end
end

# User.delete_all

# User.create(name: "tanaka",age: 25)
# User.create(name: "kimura",age: 19)
# User.create(name: "takahashi",age: 40)
# User.create(name: "mori",age: 12)
# User.create(name: "tashiro",age: 34)

# pp User.select(:id,:name,:age).all
# pp User.last
# pp User.first(3)

# pp User.select(:name,:age).find(3)

# # 全部同じ
# pp User.find_by(name: "tanaka")
# pp User.find_by name: "tanaka"
# pp User.find_by_name "tanaka"

# pp User.select("id, name, age").find_by_name('Kiriya')
# # pp User.select("id, name, age").find_by_name!('Kiriya')

# pp User.select("id, name, age").where(age: 20..35)
# pp User.select("id, name, age").where(age: [12,19])

# 同じ意味
# pp User.select("id, name, age").where("age >= 20").where("age <= 32")
# pp User.select("id, name, age").where("age >= 20 and age <= 32")

# pp User.select("id, name, age").where("age <= 20 or age >= 40")
# pp User.select("id, name, age").where("age <= 20").or(User.select("id, name, age").where("age >= 40"))
# pp User.where("age <= 20").or(User.where("age >= 40")).select("id, name, age")

# pp User.select("id, name, age").where.not(id: 3)

#==================================================================
# User.create(name: "tanaka",age: 25)
# User.create(name: "kimura",age: 19)
# User.create(name: "takahashi",age: 40)
# User.create(name: "mori",age: 12)
# User.create(name: "tashiro",age: 34)

# min = 20
# max = 30

# SQLインジェクションの危険があるので以下のコードはだめ！
# pp User.select("id, name, age").where("age <= #{min} or age >= #{max}")
# プレースホルダーなら安心
# pp User.select("id, name, age").where("age <= ? or age >= ?",min ,max)
# ？が増えると難解だから、シンボルもOK
# pp User.select("id, name, age").where("age <= :min or age >= :max",{min: min, max: max})

# プレースホルダーが大切
# pp User.select("id, name, age").where("name LIKE ?","%i")

# pp User.select("id, name, age").order(age: :desc)
# pp User.select("id, name, age").order("age desc")

# pp User.select("id, name, age").order(age: :desc).limit(3)
# pp User.select("id, name, age").order(age: :desc).limit(3).offset(1)

# pp User.top(2)

#=====================================================
# 探してなければcreate
# user = User.find_or_create_by(name: "tanaka")
# pp user

# user = User.find_or_create_by(name: "ishihara") do |u|
#  u.age = 29
# end
# pp user

#=========================================
# 更新
# User.update(1, age:50)
# pp User.select("id, name, age").find(1)

# User.where(name: "miyamoto").update(age: 70)
# pp User.find(7)

# User.where("age >= 20").update(age: 80)
# pp User.all

# User.where("age >= 60").update_all(" age = age + 2")
# pp User.all

#=========================================
# 削除

# deleteは単機能で高速
# User.delete(1)
# pp User.select("id, name, age")
# User.where("age >= 80").delete_all
# pp User.select("id, name, age")

# destroyは高機能で低速

#========================================
#validationについて

# delete, destroy
# before_destroy
# after_destroy

User.where(age: nil).destroy_all

