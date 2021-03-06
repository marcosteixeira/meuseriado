class UsersController < ApplicationController

  before_filter :authenticate_user!, :except => [:show, :index, :carregar_series, :carregar_personagens]

  def show
    #removi eager
    @user = User.friendly.find(params[:id])
  end

  def index
    redirect_to root_path
  end

  def carregar_series
    @user = User.friendly.find(params[:id])
    @series = @user.series
    render :json => {:status => :ok, :series => @series.as_json}
  end

  def carregar_personagens
    @user = User.friendly.find(params[:id])
    @personagens = @user.personagens
    render :json => {:status => :ok, :personagens => @personagens.as_json(:include => {:serie => {:only => :slug}})}
  end

  def adicionar_amigo
    @user = User.friendly.find(params[:id])
    if @user.id != current_user.id
      current_user.invite @user
    end
    redirect_to :back
  end

  def aceitar_amigo
    @user = User.friendly.find(params[:id])
    if @user.id != current_user.id
      current_user.approve @user
    end
    redirect_to :back
  end

  def recusar_amigo
    @user = User.friendly.find(params[:id])
    if @user.id != current_user.id
      current_user.block @user
    end
    redirect_to :back
  end

  def desbloquear_amigo
    @user = User.friendly.find(params[:id])
    if @user.id != current_user.id
      current_user.unblock @user
    end
    redirect_to :back
  end

  def excluir_amigo
    @user = User.friendly.find(params[:id])
    if @user.id != current_user.id
      current_user.remove_friendship @user
    end
    redirect_to :back
  end

end
