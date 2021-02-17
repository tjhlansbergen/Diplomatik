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

    if course_to_link.customer_id != @api_user.customer_id
      # vak van andere klant, retourneer foutmelding
      render_status :forbidden
      return
    end

    # koppelen van kwalificatie aan vak
    if params[:add].present? 

      # vindt de te koppelen kwalificatie
      qualification_to_link = Qualification.find(params[:add])

      if qualification_to_link.customers.exclude?(@api_user.customer)
        # kwalificatie niet gekoppeld aan klant
        render_status :forbidden
        return
      end

      # vul koppeltabel
      if course_to_link && qualification_to_link
        unless course_to_link.qualifications.include? qualification_to_link
          course_to_link.qualifications.append(qualification_to_link)
          log self.class.name, LogEntry::INFORMATIONAL, "Kwalificatie #{qualification_to_link.name} gekoppeld aan vak #{course_to_link.name} door #{@api_user.username}}"
        end
      end

    end

    # ONTkoppelen van kwalificatie van vak
    if params[:remove].present?

      # vindt de te koppelen kwalificatie
      qualification_to_unlink = Qualification.find(params[:remove])

      # verwijder uit koppeltabel
      if course_to_link && qualification_to_unlink
        if course_to_link.qualifications.include?(qualification_to_unlink)
          course_to_link.qualifications.delete(qualification_to_unlink)
          log self.class.name, LogEntry::INFORMATIONAL, "Kwalificatie #{qualification_to_unlink.name} ontkoppeld van vak #{course_to_link.name} door #{@api_user.username}}"
        end
      end
    end

  end

  # gedeelde methode voor verifieren van invoer
  private 
  def course_params
    params.require(:api_course).permit(:name, :code).merge(customer: @api_user.customer)
  end
end