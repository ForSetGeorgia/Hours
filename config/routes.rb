BootstrapStarter::Application.routes.draw do

	#--------------------------------
	# all resources should be within the scope block below
	#--------------------------------
	scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

		match '/admin', :to => 'admin#index', :as => :admin, :via => :get
		devise_for :users, :path_names => {:sign_in => 'login', :sign_out => 'logout'},
											 :controllers => {:omniauth_callbacks => "omniauth_callbacks"}


		namespace :admin do
      resources :organizations
      resources :projects do
        collection do
          get 'migrate'
          post 'migrate'
        end
      end
      resources :groups
      resources :stages
      resources :project_types
      resources :pages
			resources :users
		end

    resources :timestamps

    # summary pages
    match '/summary', :to => 'summary#index', :as => :summary, :via => :get
    match '/summary/user', :to => 'summary#user', :as => :summary_user, :via => :get
    match '/summary/project', :to => 'summary#project', :as => :summary_project, :via => :get
    match '/summary/project_date_map/:id', :to => 'summary#project_date_map', :as => :summary_project_date_map, :via => :get, format: :json
    match '/summary/user_date_map/:id', :to => 'summary#user_date_map', :as => :summary_user_date_map, :via => :get, format: :json
    match '/summary/date', :to => 'summary#date', :as => :summary_date, :via => :get

		root :to => 'root#index'
	  match "*path", :to => redirect("/#{I18n.default_locale}") # handles /en/fake/path/whatever
	end

	match '', :to => redirect("/#{I18n.default_locale}") # handles /
	match '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
