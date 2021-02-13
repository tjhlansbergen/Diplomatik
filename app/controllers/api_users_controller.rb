# api_users_controller.rb - Tako Lansbergen 2020/01/26
# 
# Controller voor het API endpoint voor API gebruikers van de Diplomatik web-api 
# overerft ApiController

class ApiUsersController < ApiController
    include LogHelper   # ten behoeve van logging 
    
    # toont bestaande gebruikers voor de klant van de ingelogde gebruiker
    def index
      @users = ApiUser.where(customer_id: @api_user.customer_id)
      render json: @users, :except => [:password_digest]
    end

    # voegt API gebruiker toe
    def create

      # verifieer of deze api gebruiker api gebruikers mag aanmaken
      if not @api_user.can_add_users
        render_status :forbidden
        return
      end

      # instancieer nieuwe gebruiker met klant-id van ingelogde gebruiker
      new_user = ApiUser.new(username: params[:username], password: params[:password], can_add_users: params[:can_add_users], customer_id: @api_user.customer_id)

      # valideer de gegevens
      if not new_user.valid?
        render_status :unprocessable_entity
        new_user = nil
        return
      end

      # nieuwe gebruiker opslaan
      new_user.save
      if new_user.persisted?
        # aanmaken gelukt, schrijf log en retourneer de aangemaakte gebruiker, als indicatie dat de actie succesvol was
        log self.class.name, LogEntry::INFORMATIONAL, "App-gebruiker #{new_user.username} aangemaakt door #{@api_user.username}"
        render json: new_user, :except => [:password_digest] 
      else
        # aanmaken niet gelukt, retourneer error
        render_status :internal_server_error
      end
    end

    # update

    # verwijder app-gebruiker
    def destroy

      # verifieer of deze api gebruiker api gebruikers mag aanmaken (en daarmee dus ook verwijderen)
      if not @api_user.can_add_users
        render_status :forbidden
        return
      end

      # vind de te verwijderen gebruiker
      user_to_delete = ApiUser.find(params[:id])

      # verwijder app-gebruiker als deze bij de klant van e ingelogde gebruiker hoort
      if user_to_delete.customer_id == @api_user.customer_id
        user_to_delete.destroy
        # verwijderen gelukt, schrijf log en retourneer de aangemaakte gebruiker, als indicatie dat de actie succesvol was
        log self.class.name, LogEntry::INFORMATIONAL, "App-gebruiker #{user_to_delete.username} verwijderd door #{@api_user.username}"
      else
        # gebruiker van andere klant, retourneer foutmelding
        render_status :forbidden
      end
    end

end
