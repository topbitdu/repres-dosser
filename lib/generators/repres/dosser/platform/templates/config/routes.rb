  scope '/platform_name-api/version_name', module: 'platform_name/dosser/version_name', as: 'platform_name_dosser_version_name' do
    resources :portals, only: :show
  end
