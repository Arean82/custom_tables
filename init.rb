# init.rb
Redmine::Plugin.register :custom_tables do
  name 'Custom Tables plugin'
  author 'Arean Narrayan'
  description 'This is a plugin for Redmine'
  version '1.1.2'
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

  Redmine::FieldFormat::UserFormat.customized_class_names << 'CustomEntity'
end

Redmine::MenuManager.map :admin_menu do |menu|
  menu.push :custom_tables, :custom_tables_path, caption: :label_custom_tables,
            :html => {:class => Redmine::VERSION::MAJOR > 5 ? 'icon' : 'icon icon-package'}
end

Dir[File.join(File.dirname(__FILE__), '/lib/custom_tables/**/*.rb')].each { |file| require_dependency file }

require File.expand_path('../lib/custom_tables/custom_entities_controller_patch', __FILE__)

Rails.configuration.to_prepare do
  require_dependency 'custom_entities_controller'
  require_dependency 'custom_tables_controller'
  require_dependency 'table_fields_controller'
  
  # Include the permission module in all controllers
  [CustomEntitiesController, CustomTablesController, TableFieldsController].each do |controller|
    controller.include(CustomTables::PermissionModule) unless controller.include?(CustomTables::PermissionModule)
  end
  
  # Also include in the existing patch
  CustomEntitiesController.include(CustomTables::CustomEntitiesControllerPatch)
end

#require File.expand_path('../lib/custom_tables/patches/followups_loader_patch', __FILE__)
require_dependency File.expand_path('lib/custom_tables/patches/followups_loader_patch', __dir__)