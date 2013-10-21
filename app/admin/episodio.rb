ActiveAdmin.register Episodio do
  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  config.per_page = 10
end
