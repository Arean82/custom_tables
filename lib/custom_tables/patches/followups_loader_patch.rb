# lib/custom_tables/patches/followups_loader_patch.rb
# Safely registers the Customer Follow-up table after plugin load

module CustomTables
  module Patches
    module FollowupsLoaderPatch
      def self.load_followup_table
        Rails.configuration.to_prepare do
          begin
            if defined?(CustomTables::Config)
              unless CustomTables::Config.tables.key?(:followups)
                CustomTables::Config.register_table(:followups, {
                  label: 'Customer Follow-up',
                  columns: [
                    { name: 'call_customer', type: 'string',  label: 'Call Customer' },
                    { name: 'next_followup_date', type: 'date', label: 'Next Follow-up Date' },
                    { name: 'followup_count', type: 'integer', label: 'Follow-up Count', default: 0 },
                    { name: 'send_quote', type: 'boolean', label: 'Send Quote', default: false },
                    { name: 'renewal_completed', type: 'boolean', label: 'Renewal Completed', default: false },
                    { name: 'tagging_completed', type: 'boolean', label: 'Tagging Completed', default: false },
                    { name: 'description', type: 'text', label: 'Description',
                      input: :textarea, rows: 6, cols: 80 },
                    { name: 'created_by_id', type: 'user', label: 'Created By', readonly: true },
                    { name: 'created_at', type: 'datetime', label: 'Created On', readonly: true }
                  ]
                })
                Rails.logger.info '[CustomTables] Customer Follow-up table registered'
              end
            else
              Rails.logger.warn '[CustomTables] CustomTables::Config not defined yet'
            end
          rescue => e
            Rails.logger.error "[CustomTables] Failed to register Followups: #{e.message}"
          end
        end
      end
    end
  end
end

# Trigger registration immediately
CustomTables::Patches::FollowupsLoaderPatch.load_followup_table
