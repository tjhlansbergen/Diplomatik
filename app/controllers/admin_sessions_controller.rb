class AdminSessionsController < AdminController
  include LogHelper
  skip_before_action :authorized, only: [:new, :create]

  def new
    # toont admin_sessions/new.html.erb
  end

  def create
    @admin_user = AdminUser.find_by(username: params[:username])
    if @admin_user && @admin_user.authenticate(params[:password])
      session[:admin_user_id] = @admin_user.id
      log LogEntry::INFORMATIONAL, "Admin user #{@admin_user.username} logged in"
      redirect_to root_path
    else
        flash.now[:error] = "Foutieve gebruikersnaam of wachtwoord" 
        render :new
    end
 end

  def admin_logout
    session[:admin_user_id] = nil
    redirect_to '/admin_login'
  end

end
