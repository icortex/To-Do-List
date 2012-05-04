class Task < ActiveRecord::Base
  attr_accessible :deadline, :done, :name

  validates_presence_of :name
  validates_length_of :name, maximum: 50

  scope :active, where('deadline >= ?', Date.today)
  scope :pending, where(done: false).active
  scope :done, where(done: true)
  scope :expired, where('deadline < ? AND done = ?', Date.today, false)

  def self.search(params)
    ap 'the raw params'
    ap params
    if params[:q]
      params[:q] = {s: 'deadline asc'}.merge(params[:q])
    else
      params[:q] = {s: 'deadline asc'}
    end

    ap 'query params'
    ap params[:q]
    q = ransack(params[:q])
    task = q.result.paginate(:page => params[:page], :per_page => 10)
    [q, task]

  end

  def status
    'expired' if deadline && self.expired?
  end

  def expired?
    self.deadline.try(:<, Date.today) && !self.done?
  end

  def mark_as_done
    self.done = true
    save
  end
end
