class Task < ActiveRecord::Base
  attr_accessible :deadline, :done, :name

  validates_presence_of :name
  validates_length_of :name, maximum: 32

  scope :pending, where('deadline >= ? AND done = ?', Time.now.utc.to_date, false)
  scope :done, where(done: true)
  scope :expired, where('deadline < ? AND done = ?', Time.now.utc.to_date, false)

  def status
    'expired' if deadline && self.expired?
  end

  def expired?
    self.deadline.try(:<, Time.now.utc.to_date) && !self.done?
  end

  def mark_as_done
    self.done = true
    save
  end
end
