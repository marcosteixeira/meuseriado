Meuseriado::Application.routes.draw do
  
  get "autocomplete/index"
  devise_for :users,  :controllers => {:registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks"}
  resources :users, :only => [:index, :show]
  resources :series, :only => [:show, :index,:create]
  resources :episodios, :only => [:show, :index]
  root :to => "home#index"
  
  resources :series do
    resources :temporadas
  end
  
  resources :episodios do
    member do
      get :marcar
    end
  # url: /episodios/:id/marcar
  # named_route: marcar_episodio_path
  end
  
  resources :series do
    member do
      get :adicionar
      get :marcar_toda
    end
  # url: /series/:id/adicionar
  # named_route: adicionar_episodio_path
  end
  
    resources :temporadas do
    member do
      get :marcar_toda
    end
  end


end
