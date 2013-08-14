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
    resources :avaliacoes
  end
  
  resources :episodios do
    member do
      post :marcar
    end
  # url: /episodios/:id/marcar
  # named_route: marcar_episodio_path
  end
  
  resources :series do
    member do
      post :adicionar
    end
  # url: /series/:id/adicionar
  # named_route: adicionar_episodio_path
  end

end
