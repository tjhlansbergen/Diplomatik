# qualification_controller.rb - Tako Lansbergen 2020/02/21
# 
# Controller voor het API endpoint voor Kwalificaties van de Diplomatik web-api 
# overerft ApiController

class ApiQualificationsController < ApiController
  include LogHelper   # ten behoeve van logging 

  def create
    if result = Qualification.create!(qualification_params)
      # aanmaken gelukt, schrijf log en retourneer de aangemaakte kwalificatie, als indicatie dat de actie succesvol was
      log self.class.name, LogEntry::INFORMATIONAL, "Kwalificatie #{result.name} aangemaakt door #{@api_user.username}, klant id #{@api_user.customer_id}"

      # vol koppeltabel
      result.customers.push(@api_user.customer)

      render json: result
    else
      render_status :unprocessable_entity
    end
  end

  # gedeelde methode voor verifieren van invoer
  private 
  def qualification_params
    params.require(:api_qualification).permit(:qualification_type_id, :name, :organization)
  end
end