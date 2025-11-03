class CustomEntity < CustomTables::ActiveRecordClass.base
  include Redmine::SafeAttributes
  include CustomTables::ActsAsJournalize

  belongs_to :custom_table
  belongs_to :issue
  has_one    :project, through: :issue
  has_many   :custom_fields, through: :custom_table

  # ✅ Audit tracking relationships
  belongs_to :author,     class_name: 'User', foreign_key: 'author_id', optional: true
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id', optional: true

  safe_attributes(
    'custom_table_id', 'author_id', 'updated_by_id',
    'custom_field_values', 'custom_fields',
    'parent_entity_ids', 'sub_entity_ids',
    'issue_id', 'external_values'
  )

  acts_as_customizable
  acts_as_watchable

  delegate :main_custom_field, to: :custom_table

  self.journal_options = {}

  # ✅ Automatically set audit fields
  before_create :set_author
  before_save   :set_updated_by

  def name
    if new_record?
      custom_table.name
    else
      custom_value = custom_values.detect { |cv| cv.custom_field == custom_table.main_custom_field }
      custom_value.try(:value) || '---'
    end
  end

  def editable?(user = User.current)
    return true if user.admin? || custom_table.is_for_all
    user.allowed_to?(:edit_issues, issue.try(:project))
  end

  def visible?(user = User.current)
    user.allowed_to?(:view_custom_tables, nil, global: true) ||
      user.allowed_to?(:manage_custom_tables, nil, global: true)
  end

  def deletable?(user = nil)
    editable?
  end

  def leaf?; false; end
  def is_descendant_of?(p); false; end

  def each_notification(users, &block); end
  def notified_users; []; end
  def notified_mentions; []; end
  def attachments; []; end

  def available_custom_fields
    custom_fields.sorted.to_a
  end

  #def created_on
  ## created_at; 
  #  respond_to?(:created_at) ? created_at : updated_at
  #end
  def created_on
    # Use updated_at as fallback if created_at doesn't exist
    if respond_to?(:created_at) && created_at.present?
      created_at
    else
      updated_at
    end
  end
  def updated_on; updated_at; end

  def value_by_external_name(external_name)
    custom_field_values.detect { |v| v.custom_field.external_name == external_name }.try(:value)
  end

  def external_values=(values)
    custom_field_values.each do |cf_value|
      key = cf_value.custom_field.external_name
      next unless key.present?
      if values.has_key?(key)
        cf_value.value = values[key]
      end
    end
    @custom_field_values_changed = true
  end

  def to_h
    values = {}
    custom_field_values.each do |value|
      if value.custom_field.external_name.present?
        values[value.custom_field.external_name] = value.value
      end
    end
    values['id'] = id
    values
  end

  private

  # 🧠 Auto-assign author/updated_by fields
  def set_author
    self.author_id ||= User.current.id if User.current
  end

  def set_updated_by
    self.updated_by_id = User.current.id if User.current
  end
end
