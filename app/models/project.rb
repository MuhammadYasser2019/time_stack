class Project < ActiveRecord::Base
  belongs_to :customer
  has_many :tasks
  has_many :time_entries
  has_many :projects_users
  has_many :users , :through => :projects_users
  accepts_nested_attributes_for :tasks, allow_destroy: true
  
  def self.task_value(task_attributes, previous_codes)
    logger.debug("Checking the tasks in projects model")
    task_value = Array.new
    task_attributes.each do |t|
      logger.debug("#############333 #{t[1]["code"].inspect}")
      code = t[1]["code"]
      task_value << code

    end
    logger.debug("########task_value #{task_value.inspect}")
    previous_codes |= task_value
    logger.debug "PREVIOUS CODES: #{previous_codes.inspect}"
    return previous_codes
  end
  
  def self.previous_codes(project)
    codes = Array.new
    project.tasks.each do |t|
      codes << t.code
    end
    return codes
  end
end
