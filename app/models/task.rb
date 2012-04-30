class Task < ActiveRecord::Base
  attr_accessible :deadline, :done, :name

  validates_presence_of :name
end
