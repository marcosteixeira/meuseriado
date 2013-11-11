ActiveAdmin.register Parceiro do
  controller do
    def permitted_params
      params.permit(:parceiro => [:nome, :email, :link])
    end
  end
end
