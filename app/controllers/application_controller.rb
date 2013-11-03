#coding: utf-8
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  after_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" && \
        request.fullpath != "/users/sign_up" && \
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    "#{session[:previous_url]}?bxmh=Q2HY3UDtGXH2" || "#{root_path}?bxmh=Q2HY3UDtGXH2"
  end

  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path
  end

  def authenticate_admin_user!
    authenticate_user!
    unless current_user.admin?
      flash[:alert] = "This area is restricted to administrators only."
      redirect_to root_path
    end
  end

  def current_admin_user
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end

  #rescue_from Exception, :with => :handle_public_excepton

  protected

  def handle_public_excepton(exception)
    @exception = exception
    render :template => "shared/exception"
  end


end
