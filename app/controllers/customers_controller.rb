# customer_controller.rb - Tako Lansbergen 2020/01/26
# 
# Controller voor klantbeheer voor de Admin webinterface van de Diplomatik web-api 
# overerft AdminController

class CustomersController < AdminController
  include LogHelper   # ten behoeve van logging

  # toont views/customers/index.html.erb en laadt het benodigde model voor de view
  def index
    @customers = Customer.all
  end

  # toont views/customers/new.html.erb met nieuw geinitialiseerde klant
  def new
    @customer = Customer.new
  end

  # toont naam-wijzigen formulier voor de gevraagde klant
  def edit
    @customer = Customer.find(params[:id])
  end

  # maakt een nieuw klant aan aan de hand van de opgegeven gegevens
  def create
    @customer = Customer.new(customer_params)
    @customer.deleted = false   # nieuwe klanten expliciet op niet-verwijderd zetten

    if @customer.save
      # aanmaken gelukt, schrijft logentry en toon overzicht
      log LogEntry::INFORMATIONAL, "Klant #{@customer.name}, id #{@customer.id}, is aangemaakt door #{current_admin_user.username}"
      redirect_to customers_path
    else
      # aanmaken niet gelukt, toon formulier opniew (met foutmelding
      render :new
    end
  end

  # werkt klantnaam bij voor de gevraagde gebruiker
  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      # wijzigen gelukt, schrijft logentry en toon overzicht
      log LogEntry::INFORMATIONAL, "Klantnaam voor klant id #{@customer.id} is gewijzigd door #{current_admin_user.username}"
      redirect_to customers_path
    else
      # wijzigen niet gelukt, toon formulier opnieuw (met foutmelding)
      render :edit
    end
  end

  # verwijdert (soft) een klant
  def destroy
    @customer = Customer.find(params[:id])
    # 'soft' delete de klant, (de namen van) historische klanten blijven behouden in de database
    @customer.deleted = true
    @customer.save
    log LogEntry::INFORMATIONAL, "Klant #{@customer.name}, id #{@customer.id}, is verwijderd door #{current_admin_user.username}"
    redirect_to customers_path
  end

  # gedeelde methode voor verifieren van invoer
  def customer_params
    params.require(:customer).permit(:name)
  end

end
