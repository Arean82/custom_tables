#table_fields_controller.rb

class TableFieldsController < CustomFieldsController
  layout 'admin'
  self.main_menu = false

  helper :custom_fields
  helper :custom_tables
  helper :queries
  include QueriesHelper
  # Add permission helper
  helper :custom_tables_permission

  before_action :authorize_global
  before_action :build_new_custom_field, only: [:new, :create]
  # ADD: Check permissions
  before_action :check_manage_permission, except: [:show, :index]

  def new
    @custom_table = CustomTable.find(params[:custom_table_id])
    @tab = @custom_table.name
    super
  end

  def create
    if @custom_field.save
      flash[:notice] = l(:notice_successful_create)
      respond_to do |format|
        format.html do
          redirect_back_or_default custom_table_path(id: @custom_field.custom_table)
        end
        format.js
      end
    else
      respond_to do |format|
        format.js { render action: 'new' }
        format.html { render action: 'new' }
      end
    end
  end

  def edit
    @tab = @custom_field.custom_table.name

    respond_to do |format|
      format.js
      format.html
    end
  end

  def update

    @custom_field.safe_attributes = params[:custom_field]
    if @custom_field.save
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_update)
          redirect_back_or_default custom_table_path(@custom_field.custom_table)
        }
        format.js { head 200 }
      end
    else
      respond_to do |format|
        format.html { render action: 'edit'}
        format.js { head 422 }
      end
    end
  end

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

  def destroy
    table = @custom_field.custom_table
    @custom_field.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = l(:notice_successful_delete)
        redirect_back_or_default custom_table_path(id: table)
      }
      format.api { render_api_ok }
    end
  end

  private

  def build_new_custom_field
    @custom_field = CustomEntityCustomField.new
    @custom_field.safe_attributes = params[:custom_field]
  end

  private

  def check_manage_permission
    unless custom_tables_user_has_full_access?
      Rails.logger.warn "🚫 MANAGE PERMISSION REQUIRED: #{User.current.login} attempted #{action_name}"
      render_403
      return false
    end
  end

end