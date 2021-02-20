# admin_controller.rb - Tako Lansbergen 2020/01/28
# 
# Controller voor beheerinterface van de Diplomatik web-api 
# overerft van ActionController::Base

class AdminController < ActionController::Base
  before_action :authorized               # vereist een ingelogde gebruiker voor alle pagina's
  helper_method :current_admin_user       # maakt de methode beschikbaar voor views
  helper_method :admin_logged_in?         # maakt de methode beschikbaar voor views

  # maakt de ingelogde beheerder van de huidige sessie beschikbaar voor deze en child-klassen
  def current_admin_user    
    AdminUser.find_by(id: session[:admin_user_id])  
  end

  # bepaalt of er momenteel een beheerder ingelogd is voor de huidige sessie
  def admin_logged_in?
    !current_admin_user.nil?  
  end

  # bepaalt of een pagina getoont mag worden
  def authorized
    redirect_to '/admin_login' unless admin_logged_in?
  end

  # toont views/admin/overview.html.erb en maakt de benodigde models beschikbaar voor de view
  def overview
    @customer_count = Customer.select{ |customer| customer.deleted == false }.count
    @api_user_count = ApiUser.count
    @admin_count = AdminUser.count
    @qualifications_count = Qualification.count
    @courses_count = Course.count
    @students_count = Student.count
    @log_entries = LogEntry.all.order(created_at: :desc)
  end
end