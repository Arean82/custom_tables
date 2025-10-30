module CustomTables
  module RecordRestrictPatch
    def self.included(base)
      base.class_eval do
        before_update :restrict_modifications
        before_destroy :restrict_modifications
      end
    end

    private

    def restrict_modifications
      allowed_roles = ['Administrator', 'Manager']  # You can change roles here
      unless User.current.admin? || User.current.roles.any? { |r| allowed_roles.include?(r.name) }
        errors.add(:base, 'You are not allowed to modify or delete this entry.')
        throw :abort
      end
    end
  end
end
