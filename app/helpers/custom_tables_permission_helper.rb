# app/helpers/custom_tables_permission_helper.rb
module CustomTablesPermissionHelper
  #include CustomTables::PermissionModule
  
  def custom_tables_user_has_full_access?(user = User.current)
    settings = Setting.plugin_custom_tables || {}  # Added || {} for safety
    
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

  # ADD SERIAL NUMBER HELPER METHOD
  def custom_tables_serial_numbers_enabled?
    settings = Setting.plugin_custom_tables || {}
    settings['enable_serial_numbers'] || false
  end
end