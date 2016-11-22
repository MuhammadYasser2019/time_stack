# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Status.create(status: 'NEW')
Status.create(status: 'SUBMITTED')
Status.create(status: 'APPROVED')
Status.create(status: 'REJECTED')

Role.create(id: 1, name: "User")
Role.create(id: 2, name: "CustomerManager")
Role.create(id: 3, name: "ProjectManager")
Role.create(id: 4, name: "Admin")