Meuseriado::Application.routes.draw do

  get "autocomplete/index"
  get "series/carregar_series"
  devise_for :users, :controllers => {:registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks"}
  resources :users, :only => [:index, :show]
  resources :series, :only => [:show, :index, :create]
  resources :episodios, :only => [:show, :index]
  resources :feeds
  root :to => "home#index"
  mount Commontator::Engine => '/commontator'

  resources :series do
    resources :temporadas
  end

  resources :episodios do
    member do
      get :marcar
      get :desmarcar
    end
    # url: /episodios/:id/marcar
    # named_route: marcar_episodio_path
  end

  resources :series do
    member do
      get :adicionar
      get :marcar_toda
      get :personagens
    end
    # url: /series/:id/adicionar
    # named_route: adicionar_episodio_path
  end

  resources :temporadas do
    member do
      get :marcar_toda
      get :desmarcar_toda
    end
  end

  resources :users do
    member do
      get :carregar_series
    end
  end

end
