# application_controller.rb - Tako Lansbergen 2020/01/25
# 
# Main controller van de Diplomatik web-api 
# overerft ActionContoller::Base, alle andere controllers overerven (indirect) van deze controller

class ApplicationController < ActionController::Base
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
end
