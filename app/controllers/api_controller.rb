# api_controller.rb - Tako Lansbergen 2020/01/26
# 
# Main controller voor de API van de Diplomatik web-api 
# overerft van ActionContoller:API

class ApiController < ActionController::API
  before_action :authorized     # vereist ingelogde gebruiker voor alle Endpoints (die hiervan overerven)
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found  # generieke methode voor alle API endpoints voor 404-not found
  rescue_from ActiveRecord::RecordInvalid, :with => :record_invalid # generieke methode voor alle API endpoints voor 422-invalid

  def record_not_found
    render_status :not_found
  end

  def record_invalid
    render_status :unprocessable_entity
  end

  # versleutelt gebruikersgegevens als token voor toegang tot de API endpoints na inloggen
  def encode_token(payload)
    payload[:exp] = 24.hours.from_now.to_i
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
        nil # toegang wordt geweigerd als het token onjuist of verlopen is, toon de precieze reden bewust niet om geen informatie prijs te geven over de levensduur van het token
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

  # verifieerd of de API gebruiker geauthoriseerd is aan de hand van het token in het request door achtereenvolgens logged_in, logged_in_api_user, decoded_token & auth_header aan te roepen
  def authorized
    render_status :unauthorized unless logged_in?
  end

  # generieke methode voor het retourneren van een status met bijbehorende beschrijving, 
  # zie https://guides.rubyonrails.org/layouts_and_rendering.html#the-status-option
  # voor de toegestane statussen
  def render_status(symbol)
    render json: { status_code: Rack::Utils::SYMBOL_TO_STATUS_CODE[symbol], message: symbol }, status: symbol
  end
end
