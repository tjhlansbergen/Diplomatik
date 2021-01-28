# api_users_controller.rb - Tako Lansbergen 2020/01/26
# 
# Controller voor het API endpoint voor API gebruikers van de Diplomatik web-api 
# overerft ApiController

class ApiUsersController < ApiController
    
    # voegt API gebruiker toe
    def create
      @api_user = ApiUser.create(api_user_params)
      if @api_user.valid?
        token = encode_token({user_id: @user.id})           # TODO, niet meteen inloggen en token retourneren?
        render json: {api_user: @api_user, token: token}    # TODO, niet meteen inloggen en token retourneren?
      else
        render json: {error: "Invalid username or password"}
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
        params.permit(:username, :password, :costumer_id, :can_add_users)
      end
end
