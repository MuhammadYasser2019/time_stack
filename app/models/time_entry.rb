class TimeEntry < ApplicationRecord
  belongs_to :project
  belongs_to :task
  belongs_to :week
  belongs_to :user


  before_save :calculate_hours


  def calculate_hours
  	
  	if hours.nil? && !time_out.nil? && !time_in.nil?
  		Rails.logger.debug("TimeEntry model- calculate_hours- *****TIME IN- #{time_in}")
  		self.hours = ((time_out.to_i - time_in.to_i)/3600.0).round(1)
  		Rails.logger.debug ("TimeEntry model- calculate_hours #{hours}***** time_in: #{time_in.strftime('%M')}")
  	end
  end




end
