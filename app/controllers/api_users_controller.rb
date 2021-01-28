# api_users_controller.rb - Tako Lansbergen 2020/01/26
# 
# Controller voor het beheer (aanmaken, verwijderen, inloggen) van API gebruikers van de Diplomatik web-api 
# overerft ApiController

class ApiUsersController < ApiController
    before_action :authorized, only: [:auto_login]  # create ook?
    skip_before_action :verify_authenticity_token   # voor api calls

      # toont views/customers/index.html.erb en laadt het benodigde model voor de view
    def index
      @api_users = ApiUser.all
    end

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
  
    # API user login, op basis van gebruikersnaam & wachtwoord, retourneerd het authorisatie token
    def login
      @api_user = ApiUser.find_by(username: params[:username])
  
      if @api_user && @api_user.authenticate(params[:password])
        token = encode_token({user_id: @api_user.id})
        render json: {user_id: @api_user.id, user_name: @api_user.username, customer_id:@api_user.customer_id, token: token}
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
    # TODO: nog nodig?
    def auto_login
      render json: @api_user
    end
  
    private

    # gedeelde methode voor verifieren van invoer
    def api_user_params
      params.permit(:username, :password, :costumer_id, :can_add_users)
    end
end