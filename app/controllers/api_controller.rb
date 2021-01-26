# api_controller.rb - Tako Lansbergen 2020/01/26
# 
# Main controller voor de API van de Diplomatik web-api 
# overerft ActionContoller::API

class ApiController < ActionController::API
    before_action :authorized

    # versleutelt gebruikersgegevens als token voor toegang tot de API endpoints na inloggen
    def encode_token(payload)
      JWT.encode(payload, Rails.configuration.jwt_seed)
    end
  
    # leest authorisatie headers uit
    def auth_header
        request.headers['Authorization']
    end
    
    # ontsleutel auhtorisatie token bij benaderen API endpoints
    def decoded_token
      if auth_header
        token = auth_header.split(' ')[1]
        begin
          JWT.decode(token, Rails.configuration.jwt_seed, true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end
    end
  
    # retourneert de ingelogde API gebruiker aan de hand van het opgegeven token in het request  
    def logged_in_api_user
      if decoded_token
        user_id = decoded_token[0]['user_id']
        @api_user = ApiUser.find_by(id: user_id)
      end
    end
  
    # retourneert of de API gebruiker ingelogd is aan de hand van het token in het request, de 'double-bang' operator fungeert als null-check op de waarde uit de 'logged_in_api_user' methode
    def logged_in?
      !!logged_in_api_user
    end
  
    # verifieerd of de gebruiker API gebruiker geauthoriseerd is aan de hand van het token in het request door achtereenvolgens logged_in, logged_in_api_user, decoded_token & auth_header aan te roepen
    def authorized
      render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end
end
