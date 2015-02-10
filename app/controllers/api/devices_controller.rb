module Api
	class DevicesController < ApplicationController
		skip_before_action :authorize 
		#function get device info
		def show
			#check params device_code
			if params[:device_code]
				#check device exits
				@device = Device.where(code: params[:device_code]).first
				#neu co
				if @device
					#check status
					# if don't joined tour
					if @device.status == false
						#render status =002
						render json:{status: 0, message:"Device not used",details:{name_device:@device.name,notification: 1,info:{}}}
					else
						#joined tour
						@tourguide = Tourguide.where(device_id:@device.id).first
						# @tourguide_info = @tourguide
						# @tourguide_info[:abc] = @device.lat
						# @tourguide[:lng] = @device.lng
						if @tourguide #tourguide
							#render tourguide info
								render json:{ 
												status:0,message: "Success",details:{
																	group: 1,name_device: @device.name,notification:2,info:{
																		id:@tourguide[:id],
																		name:@tourguide[:name],
																		address:@tourguide[:address],
																		tour_name:@tourguide.tours.fist.name,
																		lat:@device.lat,
																		lng:@device.lng,
																		phone:@tourguide[:phone],
																		device_id:@device.id
																		}
												}
											}
						else#traveller
							#get traveller info
							@traveller = Traveller.where(device_id:@device.id).first
							#render traveller info
							render json:{ 
											status:0,message: "Success",details:{
												group: 0,name_device: @device.name,notification:2,info:{
													id:@traveller[:id],
													name:@traveller[:name],
													address:@traveller[:address],
													tour_name:@tourguide.tours.fist.name,
													lat:@device.lat,
													lng:@device.lng,
													phone:@traveller[:phone],
													device_id:@device.id
												}
											}
										}
						end
						
					end
				else #don't already system
					#render status = 001
					render json:{status:0,message:"Device not already in system",details:{notification: 0}}
				end
			else
				render json:{status: 101, message:"miss device code"}
			end
		end
		#function add device
		def add
			if params[:company_code]
				#check company code
				@check_company = Company.where(code: params[:company_code]).first
				if @check_company
					if params[:device_code]
						@check_code = Device.where(code:params[:device_code]).first
						if @check_code
							render json:{status: 004, error:"device code already exist"}
						else
							@device = Device.new(code:params[:device_code],company_id:@check_company.id)
							@device.save
							render json: {status: 0, message:"Success"}
						end
					else
						render json:{status:101,message:"Missing device code"}
					end
				else
					render json:{status: 003,message:"Company code already exist"}
				end
			else
				
				 render json:{status:102, message:"Missing Company code"}
			end
		end
	end	
end