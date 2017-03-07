# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Status.find_or_initialize_by(id: 1, status: 'NEW') do |s|
  s.save!
end
Status.find_or_initialize_by(id: 2, status: 'SUBMITTED') do |s|
  s.save!
end
Status.find_or_initialize_by(id: 3, status: 'APPROVED') do |s|
  s.save!
end
Status.find_or_initialize_by(id: 4, status: 'REJECTED') do |s|
  s.save!
end


Role.find_or_initialize_by(id: 1, name: "User") do |n|
  n.save!
end
Role.find_or_initialize_by(id: 2, name: "CustomerManager") do |n|
  n.save!
end
Role.find_or_initialize_by(id: 3, name: "ProjectManager") do |n|
  n.save!
end
Role.find_or_initialize_by(id: 4, name: "Admin") do |n|
  n.save!
end

weeks_with_no_status = TimeEntry.where(status_id: nil).select(:week_id).collect { |w| w.week_id }.uniq

weeks_with_no_status.each do |w_id|
  TimeEntry.where(week_id: w_id).each do |te|
    te.status_id = Week.find(w_id).status_id
    te.approved_by = Week.find(w_id).approved_by
    te.approved_by = Week.find(w_id).approved_date
    te.save!
  end
end


