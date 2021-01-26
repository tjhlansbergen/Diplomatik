class CustomersController < AdminController

  # GET /customers
  def index
    @customers = Customer.all
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)
    @customer.deleted = false   # nieuwe klanten expliciet op niet-verwijderd zetten

    if @customer.save
      redirect_to customers_path
    else
      render :new
    end
  end

  # PATCH/PUT /customers/1
  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      redirect_to customers_path
    else
      render :edit
    end
  end

  # DELETE /customers/1
  def destroy
    @customer = Customer.find(params[:id])
    # 'soft' delete de klant, (de namen van) historische klanten blijven behouden in de database
    @customer.deleted = true
    @customer.save
    redirect_to customers_path
  end

  # Only allow a list of trusted parameters through.
  def customer_params
    params.require(:customer).permit(:name)
  end

end
