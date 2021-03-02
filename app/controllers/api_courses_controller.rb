# api_courses_controller.rb - Tako Lansbergen 2020/02/16
# 
# Controller voor het API endpoint voor Vakken (leerlijnen) van de Diplomatik web-api 
# overerft van ApiController

class ApiCoursesController < ApiController
  include LogHelper   # ten behoeve van logging 

  # toon een enkel item (mits behorende bij de klant)
  def show
    # haal vak op
    course_to_show = Course.find(params[:id])

    if course_to_show.customer_id == @api_user.customer_id
      render json: {course: course_to_show, qualifications: course_to_show.qualifications}
    else
      render_status :unauthorized
    end
  end

  # toon alle items (behorende bij de klant)
  def index
      render json: Course.where(customer_id: @api_user.customer_id)
  end

  # toevoegen van vakken
  def create
    if result = Course.create!(course_params)
      # aanmaken gelukt, schrijf log en retourneer het aangemaakte vak, als indicatie dat de actie succesvol was
      log self.class.name, LogEntry::INFORMATIONAL, "Vak #{result.name} aangemaakt door #{@api_user.username}, klant id #{@api_user.customer_id}"

      render json: result
    else
      render_status :unprocessable_entity
    end
  end

  # verwijderen van kwalificaties
  def destroy

    # vind het te verwijderen vak
    course_to_delete = Course.find(params[:id])

    # verwijder vak als deze bij de klant van de ingelogde gebruiker hoort
    if course_to_delete.customer_id == @api_user.customer_id

      # verwijder eerst verwijzigen (de koppelingen naar kwalificaties, niet de kwalificaties zelf)
      course_to_delete.qualifications.clear()

      course_to_delete.destroy
      # verwijderen gelukt, schrijf log 
      log self.class.name, LogEntry::INFORMATIONAL, "Vak #{course_to_delete.name} verwijderd door #{@api_user.username}"
    else
      # vak van andere klant, retourneer foutmelding
      render_status :forbidden
    end
  end

  def update

    # vindt het te koppelen vak 
    course_to_link = Course.find(params[:id])

    if course_to_link

      if course_to_link.customer_id != @api_user.customer_id
        # vak van andere klant, retourneer foutmelding
        render_status :forbidden
        return
      end

      # verwijder bestaande koppelingen
      course_to_link.qualifications.clear()

      # en stel de nieuwe in
      params[:qualification_ids].each { |id| 
        qualification_to_link = Qualification.find(id)

        if qualification_to_link.customers.exclude?(@api_user.customer)
          # kwalificatie niet gekoppeld aan klant
          render_status :forbidden
          return
        end

        # vul koppeltabel
        if course_to_link && qualification_to_link
          unless course_to_link.qualifications.include? qualification_to_link
            course_to_link.qualifications.append(qualification_to_link)
          end
        end
      }

      
      # log
      log self.class.name, LogEntry::INFORMATIONAL, "Kwalificaties #{params[:qualification_ids]} gekoppeld aan vak #{course_to_link.name} door #{@api_user.username}"

    end
  end

  # gedeelde methode voor verifieren van invoer
  private 
  def course_params
    params.require(:api_course).permit(:name, :code, :qualification_ids).merge(customer: @api_user.customer)
  end
end