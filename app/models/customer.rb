class Customer < ApplicationRecord
  has_many :projects
  accepts_nested_attributes_for :projects, allow_destroy: true, reject_if: proc { |projects| projects[:name].blank? }
end
