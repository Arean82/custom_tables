# lib/custom_tables/permission_module.rb
module CustomTables
  module PermissionModule
    def custom_tables_user_has_full_access?(user = User.current)
      settings = Setting.plugin_custom_tables || {}
      
      # If custom permissions are disabled, use your existing role-based logic
      unless settings['enable_custom_permissions']
        allowed_roles = ['Administrator', 'Manager']
        user_roles = user.roles.map(&:name)
        return user.admin? || user_roles.any? { |r| allowed_roles.include?(r) }
      end
      
      # Custom permission logic
      return true if user.admin?
      
      allowed_group_ids = settings['allowed_groups'] || []
      return false if allowed_group_ids.empty?
      
      user.groups.any? { |group| allowed_group_ids.include?(group.id.to_s) }
    end
  end
end