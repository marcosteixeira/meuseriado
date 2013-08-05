class AutocompleteController < ApplicationController
  def index
    @hash = []

    series = Serie.where("nome like '%#{params[:term]}%'")
    series.each do |serie|
      @hash << {"label" => serie.nome, "id" => serie.slug, "imagem" => serie.poster, "tipo" => "Series"}
    end
    
    personagens = Personagem.where("nome like '%#{params[:term]}%'")
    personagens.each do |personagem|
      @hash << {"label" => personagem.nome, "id" => personagem.slug, "imagem" => personagem.imagem, "tipo"=> "Personagens"}
    end
    
    respond_to do |format|
      format.json {render json: @hash}
    end
  end
end
