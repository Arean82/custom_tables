# config/initializers/custom_tables.rb
# ------------------------------------
# Custom table definition for Customer Follow-up tracking
# Works with Redmine 5.1 and custom_tables plugin

CustomTables::Config.register_table(:followups, {
  label: 'Customer Follow-up',
  columns: [
    { name: 'call_customer', type: 'string', label: 'Call Customer' },
    { name: 'next_followup_date', type: 'date', label: 'Next Follow-up Date' },
    { name: 'followup_count', type: 'integer', label: 'Follow-up Count', default: 0 },
    { name: 'send_quote', type: 'boolean', label: 'Send Quote', default: false },
    { name: 'renewal_completed', type: 'boolean', label: 'Renewal Completed', default: false },
    { name: 'tagging_completed', type: 'boolean', label: 'Tagging Completed', default: false },
    { name: 'description', type: 'text', label: 'Description', input: :textarea, rows: 6, cols: 80 },
    { name: 'created_by_id', type: 'user', label: 'Created By', readonly: true },
    { name: 'created_at', type: 'datetime', label: 'Created On', readonly: true }
  ]
})
