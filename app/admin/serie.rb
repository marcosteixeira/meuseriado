ActiveAdmin.register Serie do
  scope :sem_trailer

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end

    def permitted_params
      params.permit(:serie => [:produtora, :nome, :dia_exibicao, :horario_exibicao, :banner, :fannart, :estreia, :sinopse, :nota, :status, :poster, :trailer])
    end
  end

  index do
    column :nome
    column :dia_exibicao
    column :estreia
    column :nota
    column :status
    column :slug
    column :trailer
    default_actions
  end

  #collections
  collection_action :atualizar_todas, :method => :post do
    Serie.all.each do |serie|
      Serie.update_serie serie
    end
    redirect_to admin_series_path, notice: "Todas atualizadas"
  end

  collection_action :atualizar_status, :method => :post do
    AcompanhamentoSerie.all.each do |acompanhamento|
      if acompanhamento.avaliacao.avaliavel.finalizada?

      else

      end
    end
    redirect_to admin_series_path, notice: "Todas atualizadas"
  end

  member_action :atualizar, :method => :get do
    serie = Serie.friendly.find(params[:id])
    Serie.update_serie serie
    redirect_to admin_serie_path(serie), notice: "Serie atualizada"
  end


  action_item do
    link_to "Atualizar todas", atualizar_todas_admin_series_path, method: :post
  end

  action_item :only => :show do
    link_to "Atualizar", atualizar_admin_serie_path(serie)
  end

  filter :produtora, :as => :select, :collection => Produtora.all.collect { |o| [o.nome, o.id] }
  filter :nome
  filter :generos, :as => :select, :collection => Genero.all.collect { |o| [o.nome, o.id] }
  config.per_page = 10
end
