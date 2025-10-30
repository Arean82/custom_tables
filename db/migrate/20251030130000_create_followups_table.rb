
class CreateFollowupsTable < ActiveRecord::Migration[4.2]
  def change
    create_table :followups do |t|
      t.string  :call_customer
      t.date    :next_followup_date
      t.integer :followup_count, default: 0
      t.boolean :send_quote, default: false
      t.boolean :renewal_completed, default: false
      t.boolean :tagging_completed, default: false
      t.text    :description
      t.integer :created_by_id
      t.timestamps null: false
    end

    add_index :followups, :created_by_id
  end
end
