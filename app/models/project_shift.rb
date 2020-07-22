class ProjectShift < ApplicationRecord
  belongs_to :shift
  belongs_to :project
  has_many :time_entries
  has_many :projects_users
  has_many :users, through: :projects_users


  def shift_name
  	self.shift.name + ': ' + self.shift.start_time + ' - ' + self.shift.end_time
  end
end
