class UsersController < ApplicationController

  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_password]

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
  end



  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
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
    # @user =  ChangePasswordForm()
  end

  def update_password

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:account, :password,:password_confirmation, :name, :address, :group, :company_id)
    end
    def user_params_for_updating
      params.require(:user).permit(:name, :address, :group)
    end
  def user_params_for_changing_password
    params.require(:user).permit(:old_password, :new_password, :password_confirmation)
  end
end
