class VacationType < ApplicationRecord

	has_many :employment_type, through: :employment_type_vacation_type 
end
