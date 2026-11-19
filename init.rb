# init.rb
Redmine::Plugin.register :custom_tables do
  name 'Custom Tables plugin v2'
  author 'Arean Narrayan'
  description 'Custom Tables and Entities plugin for Redmine'
  version '2.0.0'
  requires_redmine :version_or_higher => '5.0.0'
  url 'https://github.com/Arean82/custom_tables'
  author_url 'https://github.com/Arean82/'

  # Add settings configuration
  settings default: { 'allowed_groups' => [], 'enable_custom_permissions' => false },
           partial: 'custom_tables/settings'

  permission :manage_custom_tables, {
      custom_entities: [:new, :edit, :create, :update, :destroy, :context_menu, :bulk_edit, :bulk_update],
  }, global: true

  permission :view_custom_tables, {
    custom_entities: [:show],
  }, global: true

  Redmine::FieldFormat::UserFormat.customized_class_names << 'CustomEntity' unless Redmine::FieldFormat::UserFormat.customized_class_names.include?('CustomEntity')
end

Redmine::MenuManager.map :admin_menu do |menu|
  menu.push :custom_tables, :custom_tables_path, caption: :label_custom_tables,
            :html => {:class => Redmine::VERSION::MAJOR > 5 ? 'icon' : 'icon icon-package'}
end

require_relative 'lib/custom_tables/custom_entities_controller_patch'
require_relative 'lib/custom_tables/permission_module'
require_relative 'lib/custom_tables/record_restrict_patch'
require_relative 'lib/custom_tables/acts_as_journalize'
require_relative 'lib/custom_tables/hooks'

Rails.configuration.to_prepare do
  # Include patches into core Redmine models and helpers safely
  Issue.send(:include, CustomTables::Patches::IssuePatch) unless Issue.included_modules.include?(CustomTables::Patches::IssuePatch)
  Project.send(:include, CustomTables::Patches::ProjectPatch) unless Project.included_modules.include?(CustomTables::Patches::ProjectPatch)
  CustomValue.send(:include, CustomTables::Patches::CustomValuePatch) unless CustomValue.included_modules.include?(CustomTables::Patches::CustomValuePatch)
  CustomFieldValue.send(:include, CustomTables::Patches::CustomFieldValuePatch) unless CustomFieldValue.included_modules.include?(CustomTables::Patches::CustomFieldValuePatch)
  ApplicationHelper.send(:include, CustomTables::Patches::ApplicationHelperPatch) unless ApplicationHelper.included_modules.include?(CustomTables::Patches::ApplicationHelperPatch)

  if defined?(Redmine::Export::PDF::IssuesPdfHelper)
    Redmine::Export::PDF::IssuesPdfHelper.send(:include, CustomTables::Patches::Lib::IssuePdfHelperPatch) unless Redmine::Export::PDF::IssuesPdfHelper.included_modules.include?(CustomTables::Patches::Lib::IssuePdfHelperPatch)
  end

  Redmine::FieldFormat::UserFormat.send(:prepend, CustomTables::Patches::UserFormatPatch) unless Redmine::FieldFormat::UserFormat.ancestors.include?(CustomTables::Patches::UserFormatPatch)

  # Include the permission module in custom tables controllers
  [CustomEntitiesController, CustomTablesController, TableFieldsController].each do |controller|
    controller.include(CustomTables::PermissionModule) unless controller.include?(CustomTables::PermissionModule)
  end

  # Controller permissions patch
  CustomEntitiesController.include(CustomTables::CustomEntitiesControllerPatch) unless CustomEntitiesController.included_modules.include?(CustomTables::CustomEntitiesControllerPatch)
end
