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
    commontator_thread_show(@personagem)
    @og_image = "http://meuseriado.com.br#{@personagem.imagem}"
  end

  def marcar
    @personagem = Personagem.friendly.find(params[:id])
    @personagem.marcar(current_user)

    respond_to do |format|
      format.html { redirect_to(action: "show", id: @personagem) }
      format.json { render json: @personagem, status: :ok }
    end
  end

  def desmarcar
    @personagem = Personagem.friendly.find(params[:id])
    @personagem.desmarcar(current_user)

    respond_to do |format|
      format.html { redirect_to(action: "show", id: @personagem) }
      format.json { render json: @personagem, status: :ok }
    end
  end

  def dar_nota
    @personagem = Personagem.friendly.find(params[:id])
    nota = params[:nota]
    if nota
      @personagem.marcar(current_user, nota)
    end
    redirect_to(action: "show", id: @personagem)
  end

end