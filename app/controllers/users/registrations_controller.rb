class Users::RegistrationsController < Devise::RegistrationsController
  def update
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end

    @user = User.find(current_user.id)
    if @user.update_attributes(params[:user].permit(:avatar, :name, :email, :notificar_atualizacoes_fb, :password, :password_confirmation))
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  def new
    super
  end

  private
  def resource_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_attributes, :provider, :uid, :avatar, :notificar_atualizacoes_fb)
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile_attributes, :provider, :uid, :avatar, :notificar_atualizacoes_fb)
  end
end