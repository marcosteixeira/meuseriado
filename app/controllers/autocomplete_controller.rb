class AutocompleteController < ApplicationController
  def index
    @hash = []

    series = Serie.where("nome like '%#{params[:term]}%' or nome_exibicao like '%#{params[:term]}%' ").limit(5)
    series.each do |serie|
      @hash << {"label" => serie.nome_exibicao, "id" => serie.slug, "imagem" => serie.poster, "tipo" => "Series", "serie" => serie.slug}
    end

    personagens = Personagem.where("nome like '%#{params[:term]}%'").limit(5)
    personagens.each do |personagem|
      @hash << {"label" => personagem.nome, "id" => personagem.slug, "imagem" => personagem.imagem, "tipo" => "Personagens", "serie" => personagem.serie.slug}
    end

    users = User.where("name like '%#{params[:term]}%' or email like '%#{params[:term]}%' ").limit(5)
    users.each do |user|
      @hash << {"label" => user.name, "id" => user.slug, "imagem" => user.imagem_formatada, "tipo" => "User", "serie" => nil}
    end

    respond_to do |format|
      format.json { render json: @hash }
    end
  end
end
