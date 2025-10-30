class Followup < ActiveRecord::Base
  belongs_to :creator, class_name: 'User', foreign_key: 'created_by_id'

  before_create :set_creator
  validates :call_customer, presence: true

  private

  def set_creator
    self.created_by_id ||= User.current.id if User.current
  end
end
