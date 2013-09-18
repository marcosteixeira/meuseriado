class UsersController < ApplicationController
  
  def show
    @user = User.friendly.find(params[:id])    
  end

  def index
    redirect_to root_path
  end
end
