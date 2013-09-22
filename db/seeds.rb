# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

puts 'DEFAULT USERS'
user = User.create! :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name


# require 'sequel'

# DB = Sequel.connect('sqlite://data/coords.sqlite3')
# 
# unless County.count > 0
#   counties = DB[:counties]
#   counties.each do |county|
#     County.create!(:name => county[:name],
#                  :area => county[:area_id],
#                  :code => county[:code])
#   end
# end
# 
# unless Municipality.count > 0
#   DB[:municipalities].each do |m|
#     Municipality.create! :name => m[:name], :code => m[:code]
#   end
# end
# 
# unless City.count > 0
#   DB[:coords].each do |c|
#     City.create! :name => c[:Name], :code => c[:code], :location=>[c[:lat], c[:lon]]
#   end
# end
# 
# if City.count > 0
#   munics = DB[:municipalities]
#   City.each do |c|
#     x = munics.where(Sequel.like(:subcodes, "%#{c[:code]}%")).first
#     unless x.nil?
#       mn = Municipality.where(:code => x[:code]).first
#       unless mn.nil?
#         mn.cities << c
#       end
#     end
#   end
# end
# 
# if County.count > 0
#   counties = DB[:counties]
#   Municipality.each do |m|
#     k = m.code.slice(0, 2)
#     x = counties.where(Sequel.like(:code, "#{k}%")).first
#     unless x.nil?
#       cn = County.where(:code => x[:code]).first
#       unless cn.nil?
#         cn.municipalities << m 
#       end
#     end
#   end
# end