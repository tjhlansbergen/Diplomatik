# admin_api_users_controller.rb - Tako Lansbergen 2020/01/28
# 
# Controller voor App gebruikers Admin beheerinterface van de Diplomatik web-api 
# overerft van AdminController

class AdminApiUsersController < AdminController
      
    # toont views/admin_api_users/index.html.erb en laadt het benodigde model voor de view
    def index
        @api_users = ApiUser.all
    end

    # toont views/admin_api_users/new.html.erb met nieuw geinitialiseerde app gebruiker
    def new
        @api_user = ApiUser.new
    end

end