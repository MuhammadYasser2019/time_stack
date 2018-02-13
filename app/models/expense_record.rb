class ExpenseRecord < ApplicationRecord
	mount_uploader :attachment, AttachmentUploader
	belongs_to :week
	belongs_to :project

	validates :expense_type, presence: true
	validates :date, presence: true
end