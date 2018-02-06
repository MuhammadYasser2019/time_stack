class ExpenseRecord < ApplicationRecord
	mount_uploader :attachment, AttachmentUploader
	belongs_to :week
	belongs_to :project
end