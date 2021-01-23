class AdminUsersController < AdminController
  include LogHelper
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

 def destroy
  puts 'parameters'
  puts params[:id]
  @admin_user = AdminUser.find(params[:id])
  @admin_user.destroy
  log LogEntry::INFORMATIONAL, "Beheeracount #{@admin_user.username} verwijderd"
  redirect_to '/accounts'
end

 def show
  # toont views/admin/show.html.erb
  @admin_users = AdminUser.all
end

end
