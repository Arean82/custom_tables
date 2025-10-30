# db/migrate/20251030131500_add_audit_fields_to_custom_entities.rb
#
# Safely adds audit tracking fields to custom_entities table
# Compatible with Redmine 5.x (Rails 6.1) using Migration[4.2]

class AddAuditFieldsToCustomEntities < ActiveRecord::Migration[4.2]
  def change
    # Add author_id if missing
    unless column_exists?(:custom_entities, :author_id)
      add_column :custom_entities, :author_id, :integer
    end

    # Add updated_by_id if missing
    unless column_exists?(:custom_entities, :updated_by_id)
      add_column :custom_entities, :updated_by_id, :integer
    end

    # Safely add foreign key constraints (only if method exists)
    if respond_to?(:foreign_key_exists?)
      unless foreign_key_exists?(:custom_entities, :users, column: :author_id)
        add_foreign_key :custom_entities, :users, column: :author_id, on_delete: :nullify
      end

      unless foreign_key_exists?(:custom_entities, :users, column: :updated_by_id)
        add_foreign_key :custom_entities, :users, column: :updated_by_id, on_delete: :nullify
      end
    end

    # Optional indexes for faster lookups
    add_index :custom_entities, :author_id unless index_exists?(:custom_entities, :author_id)
    add_index :custom_entities, :updated_by_id unless index_exists?(:custom_entities, :updated_by_id)
  end
end
