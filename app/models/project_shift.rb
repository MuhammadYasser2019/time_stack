class ProjectShift < ApplicationRecord
  belongs_to :shift
  belongs_to :project
end
