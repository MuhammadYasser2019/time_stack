class Task < ActiveRecord::Base
  belongs_to :project
  validates :code, uniqueness: true

end
