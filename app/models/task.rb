class Task < ApplicationRecord
  belongs_to :project
  validates :code, uniqueness: true

end
