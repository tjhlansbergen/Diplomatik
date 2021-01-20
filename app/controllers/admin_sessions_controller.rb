class AdminSessionsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :welcome]

  def new
    # verwijst naar admin_sessions/new.html.erb
  end

  def create
    @admin_user = AdminUser.find_by(username: params[:username])
    if @admin_user && @admin_user.authenticate(params[:password])
       session[:admin_user_id] = @admin_user.id
       redirect_to root_path
    else
       redirect_to '/admin_login'
    end
 end

  def admin_login
  end

  def admin_logout
    session[:admin_user_id] = nil
    redirect_to '/welcome'
  end

end
