class TimeEntry < ActiveRecord::Base
  belongs_to :task
  belongs_to :week
  belongs_to :user
end
