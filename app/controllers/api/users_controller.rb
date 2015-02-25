
	class Api::UsersController < ApplicationController
		skip_before_action :authorize
		def list
			#check the code device already in the list
			#check joined the tour
			#get tour info
			#get list users
			 unless params[:device_code] == "" or params[:device_code].nil?
				@check_exits = Device.where(code: params[:device_code]).first
				if @check_exits
					if @check_exits.status == false
						render json:{status:0, message:"Device not used",traveller_in_tour:[]}
					else
						#get tourguide info using device
						@tourguide = Tourguide.where(device_id: @check_exits.id ).first
						#get traveller info using device
						@traveller = Traveller.where(device_id:@check_exits.id).first
						if @tourguide#tourguide
								#get tour info
								@tour = @tourguide.tours.first
								#get list travellers
								@traveller_list = @tour.travellers
								@traveller_in_tour = []
								@traveller_list.each do |travel|
									@device = Device.find(travel.device_id)
									@traveller_in_tour << {     id:travel.id ,
												                name: travel.name,
												                phone: travel.phone,
												                lat: @device.lat,
												                lng: @device.lng,
												                address: travel.address,
												                gender: travel.gender == false ? "male" : "female", 
												                email: travel.email
											            }
								end
								#get list tourguides
								@tourguide_list = @tour.tourguides
								#render mobile tour info, list travellers, list tourguides
								render json:{status:0,message:"success",traveller_in_tour:@traveller_in_tour}
						else#neu la traveller 
								@tour = @traveller.tours.first
								@tourguide_list = @tour.tourguides
								@tourguide_in_tour = []
								@tourguide_list.each do |tourguide|
									@device = Device.find(tourguide.device_id)
									@tourguide_in_tour << {     id:tourguide.id ,
												                name: tourguide.name,
												                phone: tourguide.phone,
												                lat: @device.lat,
												                lng: @device.lng,
												                address: tourguide.address,
												                gender: tourguide.gender == false ? "male" : "female", 
												                email: tourguide.email
											            }
								end
								render json:{status:0,message:"Success",tour:@tour,tourguide_in_tour:@tourguide_in_tour}
						end
					end

				else
					render json:{status: 9, message:"Device code  invalid"}
				end
			else
				render json:{status:1,message:"Missing device code"}
			end
		end
		def update_position
			if params[:device_code]
				@device = Device.where(code:params[:device_code]).first
				if @device
					# render json:{device:@device}
					# render json:{post:post_params}
					# @post_params = post_params
					if post_params[:lat] ==""
						render json:{status:3, message:"Missing Lat"}
					elsif post_params[:lng] ==""
						render json:{status:4,message:"Missing lng"}
					else
						if @device.update_attributes(post_params)
							render json:{status:0,message:"success"}
						else
							render json:{status:5,message:"Can't update position"}
						end
						
					end
				else
					render json:{status: 0, message:"Device code  invalid"}
				end
			else
				render json:{status:1,message:"Missing device code"}
			end

		end
		def feedback
			if params[:device_code]
				@device = Device.where(code:params[:device_code]).first
				@traveller = Traveller.where(device_id:@device.id).first
				@params_feedback = params_feedback
				@params_feedback[:traveller_id] = @traveller.id
				@feedback = Feedback.new(@params_feedback)
				if @feedback.save
					render json:{status:0, message:"success"}
				else
					render json:{status:2,message:"Can't send feedback"}
				end
			else
				render json:{status:1,message:"Missing device code"}
			end
			
		end
		def push

		end
		private
		def params_feedback
			params.permit(:quantiy_service,:comment)
		end
		def post_params
			params.permit(:lat,:lng)
		end
	end