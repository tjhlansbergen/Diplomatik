# admin_users_controller.rb - Tako Lansbergen 2020/01/25
# 
# Controller voor beheeraccount-beheer voor de Admin webinterface van de Diplomatik web-api 
# overerft ApplicationController

class AdminUsersController < ApplicationController
  include LogHelper   # ten behoeve van logging

  # toont views/admin_users/index.html.erb en laadt het benodigde model voor de view
  def index
    @admin_users = AdminUser.all
  end

  # toont views/admin_users/new.html.erb met nieuw geinitialiseerde AdminUser
  def new
    @admin_user = AdminUser.new
  end

  # maakt een nieuw beheeraccount aan aan de hand van de opgegeven gegevens
  def create
    result = @admin_user = AdminUser.create(admin_user_params)
    if result.persisted?
      # aanmaken gelukt, schrijft logentry en toon beheeraccounts overzicht
      log LogEntry::INFORMATIONAL, "Beheeracount #{@admin_user.username} is aangemaakt door #{current_admin_user.username}"
      redirect_to admin_users_path
    else
      # aanmaken niet gelukt, toon formulier opniew (met foutmelding)
      render :new
    end
  end

  # toont wachtwoord-wijzigen formulier voor de gevraagde gebruiker
  def edit
    @admin_user = AdminUser.find(params[:id])
  end

  # werkt wachtwoord bij voor de gevraagde gebruiker
  def update
    @admin_user = AdminUser.find(params[:id])

    if @admin_user.update(admin_user_params)
      # wijzigen gelukt, schrijf logentry en toon overzicht
      log LogEntry::INFORMATIONAL, "Beheeracount #{@admin_user.username} heeft wachtwoord gewijzigd"
      redirect_to admin_users_path
    else
      # wijzigen niet gelukt, toon formulier opnieuw (met foutmelding)
      render :edit
    end
  end

  # verwijdert een beheeraccount
  def destroy
    @admin_user = AdminUser.find(params[:id])
    @admin_user.destroy
    log LogEntry::INFORMATIONAL, "Beheeracount #{@admin_user.username} is verwijderd door #{current_admin_user.username}"
    redirect_to admin_users_path
  end

  # gedeelde methode voor verifieren van invoer
  private
    def admin_user_params
      params.require(:admin_user).permit(:username, :current_password, :password, :password_confirmation)
    end

end
