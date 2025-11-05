# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resources :custom_tables, defaults: { format: :html } do
  collection do
    get :context_menu
  end
end

resources :table_fields

resources :custom_entities, defaults: { format: :html } do
  collection do
    get :bulk_edit
    post :bulk_update
    post :context_export
    get :context_menu
    delete :index, action: :destroy
  end
  member do
    get :add_belongs_to
    get :new_note
  end
end

resources :journals, only: [] do
  member do
    get 'edit_note'
  end
end

# --------------------------------------------------------------------
# ✅ Add Redmine REST API endpoints (JSON / XML supported)
# --------------------------------------------------------------------
match '/custom_tables(.:format)',       to: 'custom_tables#index',  via: :get,    defaults: { format: 'json' }
match '/custom_tables/:id(.:format)',   to: 'custom_tables#show',   via: :get,    defaults: { format: 'json' }
match '/custom_tables(.:format)',       to: 'custom_tables#create', via: :post,   defaults: { format: 'json' }
match '/custom_tables/:id(.:format)',   to: 'custom_tables#update', via: :put,    defaults: { format: 'json' }
match '/custom_tables/:id(.:format)',   to: 'custom_tables#destroy',via: :delete, defaults: { format: 'json' }

match '/custom_tables/:custom_table_id/custom_entities(.:format)',
      to: 'custom_entities#index',
      via: :get, defaults: { format: 'json' }
match '/custom_entities/:id(.:format)',
      to: 'custom_entities#show',
      via: :get, defaults: { format: 'json' }
match '/custom_entities(.:format)',
      to: 'custom_entities#create',
      via: :post, defaults: { format: 'json' }
match '/custom_entities/:id(.:format)',
      to: 'custom_entities#update',
      via: :put, defaults: { format: 'json' }
match '/custom_entities/:id(.:format)',
      to: 'custom_entities#destroy',
      via: :delete, defaults: { format: 'json' }



