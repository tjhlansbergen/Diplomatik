class AdminUsersController < AdminController
  include LogHelper
  skip_before_action :authorized, only: [:new, :create]

  def new
    @admin_user = AdminUser.new
  end

  def create
    @admin_user = AdminUser.create(params.require(:admin_user).permit(:username, :password))
    log LogEntry::INFORMATIONAL, "Beheeracount #{@admin_user.username} is aangemaakt"
    session[:admin_user_id] = @admin_user.id
    redirect_to root_path
  end

  def edit
    @admin_user = AdminUser.find(params[:id])
  end

  def update
    @admin_user = AdminUser.find(params[:id])

    if @admin_user.update(admin_user_params)
      log LogEntry::INFORMATIONAL, "Beheeracount #{@admin_user.username} heeft wachtwoord gewijzigd"
      redirect_to '/accounts'
    else
      render :edit
    end
  end

  def destroy
    @admin_user = AdminUser.find(params[:id])
    @admin_user.destroy
    log LogEntry::INFORMATIONAL, "Beheeracount #{@admin_user.username} is verwijderd"
    redirect_to '/accounts'
  end

  def show
    # toont views/admin/show.html.erb
    @admin_users = AdminUser.all
  end

  private
    def admin_user_params
      params.require(:admin_user).permit(:current_password, :password, :password_confirmation)
    end

end
