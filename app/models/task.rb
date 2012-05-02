class Task < ActiveRecord::Base
  attr_accessible :deadline, :done, :name

  validates_presence_of :name
  validates_length_of :name, maximum: 50

  scope :active, where('deadline >= ?', Date.today)
  scope :pending, where(done: false).active
  scope :done, where(done: true)
  scope :expired, where('deadline < ?', Date.today)
end
