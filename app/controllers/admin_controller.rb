# admin_controller.rb - Tako Lansbergen 2020/01/28
# 
# Controller voor beheerinterface van de Diplomatik web-api 
# overerft van ApplicationController

class AdminController < ApplicationController

    # toont views/admin/overview.html.erb en maakt de benodigde models beschikbaar voor de view
    def overview
        @customer_count = Customer.select{ |customer| customer.deleted == false }.count
        @api_user_count = ApiUser.count
        @admin_count = AdminUser.count
        @log_entries = LogEntry.all.order(created_at: :desc)
    end
end