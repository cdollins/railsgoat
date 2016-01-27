class SessionsController < ApplicationController
  skip_before_filter :has_info
  skip_before_filter :authenticated, :only => [:new, :create]

  def new
    @url = params[:url]
    redirect_to home_dashboard_index_path if current_user
  end

  def create
    path = home_dashboard_index_path
    begin
     if params[:url].present?
      path = URI.parse(params[:url]).path
      Rails.application.routes.recognize_path(path) # raises if invalid
     end
    rescue
      path = home_dashboard_index_path
    end

    begin
      # Normalize the email address, why not
      user = User.authenticate(params[:email].to_s.downcase, params[:password])
      # @url = params[:url]
      rescue Exception => e
    end

    if user
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token if User.where(:user_id => user.user_id).exists?
      else
        session[:user_id] = user.user_id if User.where(:user_id => user.user_id).exists?
      end
      redirect_to path
    else
      flash[:error] = "Either your username and password is incorrect"
      render "new"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    reset_session
    redirect_to root_path
  end
end
