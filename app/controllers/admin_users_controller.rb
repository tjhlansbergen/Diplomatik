class AdminUsersController < AdminController
  include LogHelper
  skip_before_action :authorized, only: [:new, :create]

  def index
        # toont views/admin/index.html.erb
        @admin_users = AdminUser.all
  end

  def new
    @admin_user = AdminUser.new
  end

  def create
    result = @admin_user = AdminUser.create(admin_user_params)
    if result.persisted?
      log LogEntry::INFORMATIONAL, "Beheeracount #{@admin_user.username} is aangemaakt door #{current_admin_user.username}"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
    @admin_user = AdminUser.find(params[:id])
  end

  def update
    @admin_user = AdminUser.find(params[:id])

    if @admin_user.update(admin_user_params)
      log LogEntry::INFORMATIONAL, "Beheeracount #{@admin_user.username} heeft wachtwoord gewijzigd"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    @admin_user = AdminUser.find(params[:id])
    @admin_user.destroy
    log LogEntry::INFORMATIONAL, "Beheeracount #{@admin_user.username} is verwijderd door #{current_admin_user.username}"
    redirect_to admin_users_path
  end

  private
    def admin_user_params
      params.require(:admin_user).permit(:username, :current_password, :password, :password_confirmation)
    end

end
