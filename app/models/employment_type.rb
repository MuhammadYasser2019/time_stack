class EmploymentType < ApplicationRecord

	has_many :vacation_type, through: :employment_type_vacation_type
end
