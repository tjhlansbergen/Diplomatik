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
        render json: {error: :forbidden}, status: :forbidden
        return
      end

      # instancieer nieuwe gebruiker
      new_user = ApiUser.new(api_user_params)

      # valideer input
      if not new_user.valid?
        render json: {error: :unprocessable_entity}, status: :unprocessable_entity
        new_user = nil
        return
      end

      # voeg klant-id in (aan de hand van de ingelogde API gebruiker)
      new_user.customer_id = @api_user.customer_id

      # nieuwe gebruiker opslaan
      new_user.save
      if new_user.persisted?
        # log

        # retourneer de aangemaakte gebruiker, als indicatie dat de actie succesvol was
        render json: new_user, :except => [:password_digest] 
      else
        render json: {error: :internal_server_error}, status: :internal_server_error
      end
    end

    # update

    # destroy

    # TODO: nog nodig?
    def auto_login
      render json: @api_user
    end

    # gedeelde methode voor verifieren van invoer
    private
      def api_user_params
        params.permit(:username, :password, :can_add_users)
      end
end
