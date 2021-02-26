# api_sessions_controller.rb - Tako Lansbergen 2020/01/28
# 
# Controller voor API Endpoint voor het inloggen van App gebruikers van de Diplomatik web-api 
# overerft van ActionContoller:API

class ApiSessionsController < ApiController
  include LogHelper   # ten behoeve van logging
  skip_before_action :authorized      # maakt inloggen beschikbaar voor niet ingelogde gebruikers

  # API user login, op basis van gebruikersnaam & wachtwoord, retourneert het authorisatie token
  def login
    @api_user = ApiUser.find_by(username: params[:username])

    if @api_user && @api_user.authenticate(params[:password])
      token = encode_token({user_id: @api_user.id})
      log self.class.name, LogEntry::INFORMATIONAL, "Sessie token afgegeven aan app-gebruiker #{@api_user.username}"
      render json: {user_id: @api_user.id, user_name: @api_user.username, customer_id:@api_user.customer_id, customer_name:@api_user.customer.name, can_add_users:@api_user.can_add_users, token: token}
    else
      render_status :bad_request
    end
  end
end