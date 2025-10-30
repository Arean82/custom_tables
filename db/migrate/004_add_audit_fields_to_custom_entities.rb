class AddAuditFieldsToCustomEntities < ActiveRecord::Migration[4.2]
  def change
    unless column_exists?(:custom_entities, :author_id)
      add_column :custom_entities, :author_id, :integer
    end

    unless column_exists?(:custom_entities, :updated_by_id)
      add_column :custom_entities, :updated_by_id, :integer
    end

    # Add foreign keys only if not already present
    unless foreign_key_exists?(:custom_entities, :users, column: :author_id)
      add_foreign_key :custom_entities, :users, column: :author_id
    end

    unless foreign_key_exists?(:custom_entities, :users, column: :updated_by_id)
      add_foreign_key :custom_entities, :users, column: :updated_by_id
    end
  end
end
