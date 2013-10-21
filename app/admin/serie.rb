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

  preserve_default_filters!
  filter :produtora, :as => :select, :collection => Produtora.all.collect { |o| [o.nome, o.id] }
  config.per_page = 10
end
