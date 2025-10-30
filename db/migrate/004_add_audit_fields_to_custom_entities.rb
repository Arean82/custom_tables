class AddAuditFieldsToCustomEntities < ActiveRecord::Migration[4.2]
  def change
    add_column :custom_entities, :author_id, :integer
    add_column :custom_entities, :updated_by_id, :integer
    add_foreign_key :custom_entities, :users, column: :author_id
    add_foreign_key :custom_entities, :users, column: :updated_by_id
  end
end
