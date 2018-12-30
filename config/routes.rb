Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	namespace :api, defaults: { format: :json } do
		scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
			match 'info',         to: 'infos#show',              via: 'get'
			match 'info',         to: 'infos#create',            via: 'post'
			match 'did/new',      to: 'dids#new',                via: 'get'
			match 'did/create',   to: 'dids#create',             via: 'post'
		end
	end
end
