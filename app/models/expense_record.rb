class ExpenseRecord < ApplicationRecord
	mount_uploader :attachment, AttachmentUploader
	belongs_to :week
end