class Project < ActiveRecord::Base
  belongs_to :customer
  has_many :tasks
  has_many :time_entries
  has_many :projects_users
  has_many :users , :through => :projects_users
  accepts_nested_attributes_for :tasks, allow_destroy: true
end
