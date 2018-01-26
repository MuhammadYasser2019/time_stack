class EmploymentTypeVacationType < ApplicationRecord
	belongs_to :employment_types
	belongs :vacation_types
end
