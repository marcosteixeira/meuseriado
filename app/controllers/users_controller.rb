class UsersController < ApplicationController
  
  def show
    @user = User.friendly.find(params[:id])    
  end

  def index
    redirect_to root_path
  end

  def carregar_series

    @user = User.friendly.find(params[:id])
    @series = @user.series[5                          ,100]
    @series.size
    render :json => {:status => :ok, :series => @series.as_json}
  end
end
