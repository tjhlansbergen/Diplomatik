# admin_sessions_controller.rb - Tako Lansbergen 2020/01/25
# 
# Sessie controller voor de Admin webinterface van de Diplomatik web-api 
# overerft AdminController

class AdminSessionsController < AdminController
  include LogHelper # ten behoeve van logging
  skip_before_action :authorized, only: [:new, :create]   # maak inloggen beschikbaar (voor niet ingelogde beheerders)

  # toont admin_sessions/new.html.erb
  def new
  end

  # maakt een nieuwe sessie aan de hand van de opgegeven inloggegevens
  def create
    @admin_user = AdminUser.find_by(username: params[:username])
    if @admin_user && @admin_user.authenticate(params[:password])
      # inloggen gelukt, maak sessie, schrijf log entry en toon hoofdpagina
      session[:admin_user_id] = @admin_user.id
      log LogEntry::INFORMATIONAL, "Beheerder #{@admin_user.username} is ingelogd"
      redirect_to root_path
    else
      # inloggen mislukt, toon formulier opnieuw met melding
      flash.now[:error] = "Foutieve gebruikersnaam of wachtwoord" 
      render :new
    end
  end

  # logt een beheerder uit door de sessie te clearen
  def admin_logout
      session[:admin_user_id] = nil
      redirect_to '/admin_login'
  end
end
