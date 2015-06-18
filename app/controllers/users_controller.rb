class UsersController < ApplicationController
  require'digest/md5'
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_password, :update_password]
  before_action :check_permission ,only: [:index,:destroy]

  # GET /users
  # GET /users.json
  def index
    @company = Company.all
    @created_at = [["All","All"],["Day ago",Time.at(1.day.ago.to_i)],["Weeks ago",Time.at(1.week.ago.to_i)],["A month ago",Time.at(1.month.ago.to_i)],["Six month ago",Time.at(6.months.ago.to_i)],["Years ago",Time.at(1.year.ago.to_i)]]
    if params[:fillter]
      @users = User.find_scope("account",params[:fillter][:account])
                   .find_scope("name",params[:fillter][:name])
                   .find_scope("address",params[:fillter][:address])
                   .find_group(params[:fillter][:group])
                   .find_created(params[:fillter][:created_at])
                   .page(params[:page])
      if params[:fillter][:company] != 'All'
        @users = @users.joins(:company).where("companies.id = #{params[:fillter][:company]}")
      end
    else
       @users = User.order(:account).page(params[:page]).order("account DESC").page(params[:page])
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
    if curent_user.group == "company"
      #don't access edit other company
      if params[:id] != session[:id].to_s
           redirect_to edit_user_path(session[:id])
      end
    end
    @user.company
    @company = Company.all
  end



  # POST /users
  # POST /users.json
  def create
    @user_params = user_params
    @params_company = company_params
    @user = User.new(user_params)
    # @params_company = company_params
      if user_params["group"] == 'company'#  group is company
        if @user.save
          @company = @user.create_company(company_params)
          @company[:code] = Company.generate_company_code
          if @company.save
            redirect_to users_url, notice: 'User was successfully created.'
          else
            User.find(@user.id).destroy
            @user = User.new(user_params)
            render :new
          end
        else
          render :new
        end
      else
        if @user.save
            redirect_to users_url, notice: 'User was successfully created.'
        else
            render :new
        end
      end
    end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if curent_user.group =="company"
        @user = User.find(params[:id])
        @company = Company.find(@user.company_id)
         if @company.update(company_params) && @user.update(user_params_for_updating)
            format.html{ redirect_to user_path(params[:id], method: :get), notice:"Update successfully" }
         end
      elsif @user.update(user_params_for_updating)
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
      @user = User.find(params[:id])
  end

  def update_password
    password = user_params_for_changing_password[:password]
    @user.update(password:Digest::MD5.hexdigest(password))
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
      begin
          @user = User.find(params[:id])
      rescue ActiveRecord::RecordNotFound
         render "layouts/not_found.html.erb"
      else
          @user = User.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if curent_user.group == "company"
        params.require(:user).permit(:account, :password,:password_confirmation, :name, :address)
      else
        params.require(:user).permit(:account, :password,:password_confirmation, :name, :address, :group)
      end
    end

    def company_params
      params.require(:company).permit(:name,:address,:information)
    end

    def user_params_for_updating
      params.require(:user).permit(:name, :address, :group,:gender,:email)
    end

    def user_params_for_changing_password
      params.require(:user).permit( :password, :password_confirmation)
    end

    def params_fillter
      params.require(:fillter).permit(:account,:address,:name,:group,:company,:created_at)
    end
end
