# oauth_controller.rb - Tako Lansbergen 2020/03/06
# 
# Controller voor callbacks vanuit LinkedIn
# overerft van AdminController

class OauthController < AdminController
  include LogHelper   # ten behoeve van logging 
  skip_before_action :authorized   # maak inloggen beschikbaar voor niet ingelogde beheerders

  def callback

    # als de callback wordt aangeroepen met error, log deze en toon generieke melding
    if params[:error].present?
      log self.class.name, LogEntry::ERROR, "Fout tijdens aanmelden bij LinkedIn #{params['error']} {params['error_description']}"
      # toon inlog formulier met generieke melding (bewust, om geen informatie prijs te geven over waarom het inloggen mislukt, deze info schrijven we naar de log)
      flash.now[:error] = "Fout tijdens aanmelden via LinkedIn (1)" 
      render 'admin_sessions/new'
      return
    end

    # callback aangeroepen zonder error, haal het accces_token op bij linkedIn
    access_token = get_token params['code']

    if access_token.nil?
      log self.class.name, LogEntry::ERROR, "Fout tijdens aanmelden bij LinkedIn, callback was succesvol maar access_token is null"
      # toon inlog formulier met generieke melding (bewust, om geen informatie prijs te geven over waarom het inloggen mislukt, deze info schrijven we naar de log)
      flash.now[:error] = "Fout tijdens aanmelden via LinkedIn" 
      render 'admin_sessions/new'
      return
    end

    # Haal met het access_token de linkedIn gebruikersgegevens op
    linkindin_user = get_user access_token

    if linkindin_user.nil?
      log self.class.name, LogEntry::ERROR, "Fout tijdens aanmelden bij LinkedIn, access_token ontvangen, maar user is null"
      # toon inlog formulier met generieke melding (bewust, om geen informatie prijs te geven over waarom het inloggen mislukt, deze info schrijven we naar de log)
      flash.now[:error] = "Fout tijdens aanmelden via LinkedIn" 
      render 'admin_sessions/new'
      return
    end

    # haal de beheerder op uit de database
    @admin_user = AdminUser.find_by(username: linkindin_user['elements'][0]['handle~']['emailAddress'])

    if @admin_user
      # inloggen gelukt, maak sessie, schrijf log entry en toon hoofdpagina
      session[:admin_user_id] = @admin_user.id
      log self.class.name, LogEntry::INFORMATIONAL, "Beheerder #{@admin_user.username} is ingelogd via LinkedIn"
      redirect_to root_path
    else
      log self.class.name, LogEntry::ERROR, "Fout tijdens aanmelden bij LinkedIn, geen diplomatik gebruiker gevonden voor #{linkindin_user['elements'][0]['handle~']['emailAddress']}"
      # toon inlog formulier met generieke melding (bewust, om geen informatie prijs te geven over waarom het inloggen mislukt, deze info schrijven we naar de log)
      flash.now[:error] = "Fout tijdens aanmelden via LinkedIn" 
      render 'admin_sessions/new'
    end
  end

  # maak post naar LinkedIn API voor ophalen access-token
  def get_token(code)

    # request instellen
    # let op, redirect_url hier niet url-encoded aanbieden, dan wordt 'ie dubbel encoded
    uri = URI.parse("https://www.linkedin.com/oauth/v2/accessToken")
    uri.query = URI.encode_www_form({"grant_type" => "authorization_code", "code" => code, "redirect_uri" => Rails.configuration.oauth_redirect_url, "client_id" => Rails.configuration.oauth_client_id, "client_secret" => Rails.configuration.oauth_client_secret })
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    # request verzenden en reponse ophalen
    request = Net::HTTP::Post.new(uri.request_uri)
    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      return JSON.parse(response.body)['access_token']
    else
      return nil
    end

  end

  # maak get naar LinkedIn API voor ophalen emailadress gebruiker
  def get_user(access_token)
    
    # request instellen
    uri = URI.parse("https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    
    # request verzenden en reponse ophalen
    request = Net::HTTP::Get.new(uri.request_uri)
    request["Authorization"] = "Bearer #{access_token}"
    response = http.request(request)

    if response.is_a?(Net::HTTPSuccess)
      return JSON.parse(response.body)
    else
      return nil
    end

  end

end