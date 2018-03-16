class Clone < ApplicationRecord
	has_many :archive_week
	belongs_to :week
end
