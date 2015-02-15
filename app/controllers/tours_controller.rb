class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]

  # GET /tours
  # GET /tours.json
  def index
    if params[:search]
      @tours = Tour.search(params[:search]).order("created_at DESC").page(params[:page])
    else
      @tours = Tour.order(:name).page(params[:page])
    end
  end

  # GET /tours/1
  # GET /tours/1.json
  def show
  end

  # GET /tours/new
  def new
    @tour = Tour.new
  end

  # GET /tours/1/edit
  def edit
  end

  # POST /tours
  # POST /tours.json
  def create
    @tour = Tour.new(tour_params)

    respond_to do |format|
      if @tour.save
        format.html { redirect_to @tour, notice: 'Tour was successfully created.' }
        format.json { render :show, status: :created, location: @tour }
      else
        format.html { render :new }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tours/1
  # PATCH/PUT /tours/1.json
  def update
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to @tour, notice: 'Tour was successfully updated.' }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { render :edit }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tours/1
  # DELETE /tours/1.json
  def destroy
    @tour.destroy
    respond_to do |format|
      format.html { redirect_to tours_url, notice: 'Tour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def list_users
      @tour = Tour.find(params[:id])
      @traveller_list = @tour.travellers
      @tourguide_list = @tour.tourguides
      @tourguides = Tourguide.where("active = 0")
      @devices = Device.where("status = 0")

  end
  def add_tourguide
    @tourguide = Tourguide.find(params[:tourguide])
    @tourguide.update(active:1,device_id:params[:device])
    @device = Device.find(params[:device])
    @device.update(status:1)
    @tour = Tour.find(params[:tour_id])
    @tourguide.tours << @tour
    redirect_to list_user_path(params[:tour_id]),alert: 'Tourguide was successfully added.'
  end
  def remove_traveller
    @tour=Tour.find(params[:tour_id])
    @traveller = Traveller.find(params[:traveller_id])
    @device = Device.find(@traveller.device_id)
    #delete traveller in tour
    @traveller.tours.delete(@tour)
    #delete device in traveller
    @traveller.update(device_id:nil)
    #update status device
    @device.update(status:0)
    redirect_to list_user_path(params[:tour_id]), notice:"Traveller was successfully destroyed" 
    
  end
  def remove_tourguide
    @tour = Tour.find(params[:tour_id])
    @tourguide = Tourguide.find(params[:tourguide_id])
    @device = Device.find(@tourguide.device_id)
    #delete tourguide in tour
    @tourguide.tours.delete(@tour)
    #update device_id and active of tourguide 
    @tourguide.update(active:0,device_id:nil)
    #update status device
    @device.update(status:0)
    redirect_to list_user_path(params[:tour_id]), alert:"Tourguide was successfully destroyed"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_params
      params.require(:tour).permit(:name, :number_of_member, :information)
    end
end
