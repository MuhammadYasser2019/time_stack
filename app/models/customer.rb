class Customer < ApplicationRecord
  has_many :projects
  has_and_belongs_to_many :holidays, join_table: :customers_holidays
  accepts_nested_attributes_for :projects, allow_destroy: true, reject_if: proc { |projects| projects[:name].blank? }
end
