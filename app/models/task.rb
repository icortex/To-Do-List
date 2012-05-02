class Task < ActiveRecord::Base
  attr_accessible :deadline, :done, :name

  validates_presence_of :name
  validates_length_of :name, maximum: 50
end
