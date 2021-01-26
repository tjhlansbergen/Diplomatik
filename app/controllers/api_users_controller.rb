class ApiUsersController < ApiController
    before_action :authorized, only: [:auto_login]

    # REGISTER
    def create
      @api_user = ApiUser.create(api_user_params)
      if @api_user.valid?
        token = encode_token({user_id: @user.id})
        render json: {api_user: @api_user, token: token}
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
    # LOGGING IN
    def login
      @api_user = ApiUser.find_by(username: params[:username])
  
      if @api_user && @api_user.authenticate(params[:password])
        token = encode_token({user_id: @api_user.id})
        render json: {user_id: @api_user.id, user_name: @api_user.username, customer_id:@api_user.customer_id, token: token}
      else
        render json: {error: "Invalid username or password"}
      end
    end
  
    # TODO: nog nodig?
    def auto_login
      render json: @api_user
    end
  
    private
  
    def api_user_params
      params.permit(:username, :password, :costumer_id)
    end
end
