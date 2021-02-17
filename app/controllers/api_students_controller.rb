# api_students_controller.rb - Tako Lansbergen 2020/02/17
# 
# Controller voor het API endpoint voor Studenten van de Diplomatik web-api 
# overerft van ApiController

class ApiStudentsController < ApiController
  include LogHelper   # ten behoeve van logging 

  # toon een enkel item (mits behorende bij de klant)
  def show
    # haal student op
    student_to_show = Student.find(params[:id])

    if student_to_show.customer_id == @api_user.customer_id

      # bepaal de vrijstellingen voor de student (de vakken behorende bij zijn kwalificaties)
      exemptions = student_to_show.qualifications.collect{|q| q.courses.where(customer: @api_user.customer)}.uniq{ |course| course.name }

      render json: {student: student_to_show, qualifications: student_to_show.qualifications, exemptions: exemptions}

    else
      render_status :unauthorized
    end
  end

  # toon alle items (behorende bij de klant)
  def index
      render json: Student.where(customer_id: @api_user.customer_id)
  end

  # toevoegen van student
  def create
    if result = Student.create!(student_params)
      # aanmaken gelukt, schrijf log en retourneer de aangemaakte student, als indicatie dat de actie succesvol was
      log self.class.name, LogEntry::INFORMATIONAL, "Student #{result.name} aangemaakt door #{@api_user.username}, klant id #{@api_user.customer_id}"

      render json: result
    else
      render_status :unprocessable_entity
    end
  end

  # verwijderen van kwalificaties
  def destroy

    # vind de te verwijderen student
    student_to_delete = Student.find(params[:id])

    # verwijder student als deze bij de klant van de ingelogde gebruiker hoort
    if student_to_delete.customer_id == @api_user.customer_id
      student_to_delete.destroy
      # verwijderen gelukt, schrijf log 
      log self.class.name, LogEntry::INFORMATIONAL, "Student #{student_to_delete.name} verwijderd door #{@api_user.username}"
    else
      # student van andere klant, retourneer foutmelding
      render_status :forbidden
    end
  end

  def update

    # vindt de te koppelen student 
    student_to_link = Student.find(params[:id])

    if student_to_link.customer_id != @api_user.customer_id
      # student van andere klant, retourneer foutmelding
      render_status :forbidden
      return
    end

    # koppelen van kwalificatie aan student
    if params[:add].present? 

      # vindt de te koppelen kwalificatie
      qualification_to_link = Qualification.find(params[:add])

      if qualification_to_link.customers.exclude?(@api_user.customer)
        # kwalificatie niet gekoppeld aan klant
        render_status :forbidden
        return
      end

      # vul koppeltabel
      if student_to_link && qualification_to_link
        unless student_to_link.qualifications.include? qualification_to_link
          student_to_link.qualifications.append(qualification_to_link)
          log self.class.name, LogEntry::INFORMATIONAL, "Kwalificatie #{qualification_to_link.name} gekoppeld aan student #{student_to_link.name} door #{@api_user.username}}"
        end
      end

    end

    # ONTkoppelen van kwalificatie van student
    if params[:remove].present?

      # vindt de te koppelen kwalificatie
      qualification_to_unlink = Qualification.find(params[:remove])

      # verwijder uit koppeltabel
      if student_to_link && qualification_to_unlink
        if student_to_link.qualifications.include?(qualification_to_unlink)
          student_to_link.qualifications.delete(qualification_to_unlink)
          log self.class.name, LogEntry::INFORMATIONAL, "Kwalificatie #{qualification_to_unlink.name} ontkoppeld van student #{student_to_link.name} door #{@api_user.username}}"
        end
      end
    end

  end

  # gedeelde methode voor verifieren van invoer
  private 
  def student_params
    params.require(:api_student).permit(:name, :student_number).merge(customer: @api_user.customer)
  end
end