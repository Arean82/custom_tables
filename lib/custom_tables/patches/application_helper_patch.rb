module CustomTables
  module Patches
    module ApplicationHelperPatch
      def self.included(base)
        base.class_eval do
          # define sprite_icon for redmine 5 and ignore for redmine 6/7
          unless method_defined?(:sprite_icon)
            def sprite_icon(icon_name, label = nil, icon_only: false, size: 0, css_class: nil, sprite: 0, plugin: nil, rtl: false)
              label ? label : ''
            end
          end
        end
      end
    end
  end
end
