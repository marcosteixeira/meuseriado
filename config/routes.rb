Meuseriado::Application.routes.draw do

  ActiveAdmin.routes(self)
  get "home/onde_parei"
  get "autocomplete/index"
  get "series/carregar_series"
  get "feeds/personagens"
  get "feeds/episodios"
  get "feeds/temporadas"
  devise_for :users, :controllers => {:registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks"}
  resources :users, :only => [:index, :show]
  resources :series, :only => [:show, :index, :create]
  resources :episodios, :only => [:show, :index]
  resources :feeds
  resources :batalhas
  root :to => "home#index"
  mount Commontator::Engine => '/commontator'

  resources :series do
    resources :temporadas
    resources :personagens
  end

  resources :episodios do
    member do
      get :marcar
      get :desmarcar
      post :dar_nota
    end
    # url: /episodios/:id/marcar
    # named_route: marcar_episodio_path
  end

  resources :series do
    member do
      get :adicionar
      get :marcar_toda
      get :desmarcar
      post :inserir_trailer
      post :dar_nota
    end
    # url: /series/:id/adicionar
    # named_route: adicionar_episodio_path
  end

  resources :temporadas do
    member do
      get :marcar_toda
      get :desmarcar_toda
      post :dar_nota
    end
  end

  resources :users do
    member do
      get :carregar_series
      get :carregar_personagens
      post :adicionar_amigo
      post :aceitar_amigo
      post :recusar_amigo
      post :desbloquear_amigo
      post :excluir_amigo
    end
  end

  resources :personagens do
    member do
      get :marcar
      get :desmarcar
      post :dar_nota
    end
  end

end
