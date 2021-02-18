# api_qualification_controller.rb - Tako Lansbergen 2020/02/21
# 
# Controller voor het API endpoint voor Kwalificaties van de Diplomatik web-api 
# overerft van ApiController

class ApiQualificationsController < ApiController
  include LogHelper   # ten behoeve van logging 

  # toon een enkel item
  def show
    render json: Qualification.find(params[:id])
  end

  # toon alle items (behorende bij de klant, tenzij anders aangegeven)
  def index
    if(params[:all])
      render json: Qualification.all
    else
      render json: Qualification.includes(:customers).where(customers: { id: @api_user.customer_id}) 
    end
  end

  # toevoegen van kwalificaties
  def create
    if result = Qualification.create!(qualification_params)
      # aanmaken gelukt, schrijf log en retourneer de aangemaakte kwalificatie, als indicatie dat de actie succesvol was
      log self.class.name, LogEntry::INFORMATIONAL, "Kwalificatie #{result.name} aangemaakt door #{@api_user.username}, klant id #{@api_user.customer_id}"

      # vul koppeltabel
      result.customers.append(@api_user.customer)

      render json: result
    else
      render_status :unprocessable_entity
    end
  end

  # verwijderen van kwalificaties
  def destroy

    # haal de gevraagde kwalificatie op
    qualification_to_delete = Qualification.find(params[:id])

    if qualification_to_delete
      log self.class.name, LogEntry::INFORMATIONAL, "Kwalificatie #{qualification_to_delete.name} verwijderd voor klant id #{@api_user.customer_id} door #{@api_user.username}"

      # verwijder uit koppeltabel
      qualification_to_delete.customers.delete(@api_user.customer)

      # eventuele bestaande verwijzingen vanuit vakken en/of student blijven bestaan

      # tel verwijzingen (ook van andere klanten)
      references = qualification_to_delete.customers.count + qualification_to_delete.students.count + qualification_to_delete.courses.count

      # als er geen enkele verwijzing naar de kwalificatie meer bestaat, verwijder dan ook de kwalificatie
      if references == 0
        log self.class.name, LogEntry::INFORMATIONAL, "Kwalificatie #{qualification_to_delete.name} verwijderd"
        qualification_to_delete.destroy
      end
    end

  end

  # koppelen van bestaande kwalificaties
  def update

    # haal de gevraagde kwalificatie op
    qualification_to_link = Qualification.find(params[:id])

    # vul koppeltabel
    if qualification_to_link
      unless qualification_to_link.customers.include? @api_user.customer
        log self.class.name, LogEntry::INFORMATIONAL, "Kwalificatie #{qualification_to_link.name} toegevoegd aan klant id #{@api_user.customer_id} door #{@api_user.username}}"
        qualification_to_link.customers.append(@api_user.customer)
      end
    end
  end

  # gedeelde methode voor verifieren van invoer
  private 
  def qualification_params
    params.require(:api_qualification).permit(:qualification_type_id, :name, :organization)
  end
end