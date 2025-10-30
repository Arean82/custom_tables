class Followup < ActiveRecord::Base
  before_create :set_creator

  private

  def set_creator
    self.created_by_id ||= User.current.id if User.current
  end
end
