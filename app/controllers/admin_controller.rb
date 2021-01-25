# admin_controller.rb - Tako Lansbergen 2020/01/25
# 
# Main controller voor de Admin webinterface van de Diplomatik web-api 
# overerft ActionContoller

class AdminController < ActionController::Base
    before_action :authorized
    helper_method :current_admin_user
    helper_method :admin_logged_in?

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

    # # toont views/admin/overview.html.erb en maakt de benodigde models beschikbaar voor de view
    def overview
        @admins = AdminUser.count
        @log_entries = LogEntry.all.order(created_at: :desc)
    end

end
