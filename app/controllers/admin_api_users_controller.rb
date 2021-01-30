# admin_api_users_controller.rb - Tako Lansbergen 2020/01/28
# 
# Controller voor API (App) gebruikers Admin beheerinterface van de Diplomatik web-api 
# overerft van AdminController

class AdminApiUsersController < AdminController
    include LogHelper   # ten behoeve van logging  

    # toont views/admin_api_users/index.html.erb en laadt het benodigde model voor de view
    def index
        @api_users = ApiUser.all
    end

    # toont views/admin_api_users/new.html.erb met nieuw geinitialiseerde app gebruiker
    def new
        @api_user = ApiUser.new
    end

    # maakt een nieuw api-account aan aan de hand van de opgegeven gegevens
    def create
        result = @api_user = ApiUser.create(api_user_params)
        if result.persisted?
        # aanmaken gelukt, schrijft logentry en toon beheeraccounts overzicht
        log LogEntry::INFORMATIONAL, "App gebruiker #{@api_user.username}, klant-id #{@api_user.customer_id}, is aangemaakt door #{current_admin_user.username}"
        redirect_to admin_api_users_path
        else
        # aanmaken niet gelukt, toon formulier opniew (met foutmelding)
        render :new
        end
    end

    # verwijdert een api-account
    def destroy
        @api_user = ApiUser.find(params[:id])
        @api_user.destroy
        log LogEntry::INFORMATIONAL, "App gebruiker #{@api_user.username} is verwijderd door #{current_admin_user.username}"
        redirect_to admin_api_users_path
    end

    # gedeelde methode voor verifieren van invoer
    private
    def api_user_params
        params.require(:api_user).permit(:username, :password, :password_confirmation, :customer_id, :can_add_users)
    end

end