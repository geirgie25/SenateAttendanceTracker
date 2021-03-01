# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
general = Committee.new
general.committee_name = "General"
general.save

administrator_role = Role.new
administrator_role.role_name = "Administrator"
administrator_role.save

admin = User.new
admin.username = "admin"
admin.password = "password"
admin.name = "Administrator"
admin.roles << administrator_role
admin.save