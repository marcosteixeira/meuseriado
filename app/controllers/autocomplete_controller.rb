class AutocompleteController < ApplicationController
  def index
    @hash = []

    series = Serie.where("nome like '%#{params[:term]}%'").limit(5)
    series.each do |serie|
      @hash << {"label" => serie.nome, "id" => serie.slug, "imagem" => serie.poster, "tipo" => "Series","serie"=> serie.slug}
    end
    
    personagens = Personagem.where("nome like '%#{params[:term]}%'").limit(5)
    personagens.each do |personagem|
      @hash << {"label" => personagem.nome, "id" => personagem.slug, "imagem" => personagem.imagem, "tipo"=> "Personagens", "serie"=> personagem.serie.slug}
    end
    
    respond_to do |format|
      format.json {render json: @hash}
    end
  end
end
