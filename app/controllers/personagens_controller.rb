#coding: utf-8
class PersonagensController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    if params[:serie_id]
      @serie = Serie.friendly.find(params[:serie_id])
    else
      redirect_to root_path
    end
    
    @title = "Personagens #{@serie.nome}"
  end

  def show
    @personagem = Personagem.friendly.find(params[:id])
    @title = @personagem.nome
  end
end