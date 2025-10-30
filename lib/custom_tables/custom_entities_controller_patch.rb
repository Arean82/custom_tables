module CustomTables
  module CustomEntitiesControllerPatch
    def self.included(base)
      base.class_eval do
        before_action :set_custom_permissions, only: [:index, :show]

        private

        def set_custom_permissions
          @can_edit_or_delete = User.current.admin? || User.current.roles.any? { |r| ['Administrator', 'Manager'].include?(r.name) }
        end
      end
    end
  end
end
