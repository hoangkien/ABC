class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_password, :update_password]
   before_action :check_permission ,only: [:index,:destroy,]

  # GET /users
  # GET /users.json
  def index
    # @users = User.all
    # @users = User.order(:name).page(params[:page])
    if params[:search]
      @users = User.search(params[:search]).order("created_at DESC").page(params[:page])
    else
      @users = User.order(:account).page(params[:page])
    end
  end

  # GET /users/1
  # GET /users/1.json

  def search
    @users = User.order(:name).page(params[:page])
      render 'index'
  end
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user.company
    @company = Company.all
  end



  # POST /users
  # POST /users.json
  def create
    @user_params = user_params
     @params_company = company_params
    if user_params["group"] == 'company'
      if company_params[:name].present? == true
        check_company = Company.where(name:company_params[:name]).first
        if check_company.nil? 
          @params_company[:code] = Company.generate_company_code
          @user_params[:company_id] = Company.last.id
        else
          @company_errors="has already been taken"
        end
      else
        @company_errors = "Can't be blank"
      end
    end
    @company = Company.new( @params_company)
    @user = User.new(@user_params)
    if @user.save && @company.save
         redirect_to users_url, notice: 'User was successfully created.' 
      else
         render :new 
      end
    end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params_for_updating)

        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_password
      @password = User.find(params[:id]).password
  end

  def update_password
    @user.update(user_params_for_changing_password)
    redirect_to users_path
  end
  private
    def check_permission
      if session[:group] == 'company'
          redirect_to devices_path
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:account, :password,:password_confirmation, :name, :address, :group)
    end
    def company_params
      params.require(:company).permit(:name,:address)
    end
    def user_params_for_updating
      params.require(:user).permit(:name, :address, :group,:gender,:email)
    end
  def user_params_for_changing_password
    params.require(:user).permit( :password, :password_confirmation)
  end
end
