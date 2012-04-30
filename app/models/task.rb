class Task < ActiveRecord::Base
  attr_accessible :deadline, :done, :name
end
