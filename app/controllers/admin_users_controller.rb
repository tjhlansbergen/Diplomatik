class AdminUsersController < AdminController
  skip_before_action :authorized, only: [:new, :create]

  def new
    @admin_user = AdminUser.new
  end

  def create
    @admin_user = AdminUser.create(params.require(:admin_user).permit(:username, :password))
    # todo logging
    session[:admin_user_id] = @admin_user.id
    redirect_to root_path
 end
end
