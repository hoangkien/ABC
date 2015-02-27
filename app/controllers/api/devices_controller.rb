# module Api
	class Api::DevicesController < ApplicationController
		skip_before_action :authorize 
		skip_before_filter  :verify_authenticity_token
		#function get device info
		def show
			#check params device_code
			unless params[:device_code].empty?
				#check device exits
				@device = Device.where(code: params[:device_code]).first
				#neu co
				if @device
					#check status
					# if don't joined tour
					if @device.status == false
						#render status =002
						render json:{status: 0, message:"Device not used",details:{name_device:@device.name,notification: 1,info:{
																		id:"",
																		name:"",
																		address:"",
																		tour_name:"",
																		lat:"",
																		lng:"",
																		phone:"",
																		device_id:@device.id
																		}
																	}
															}
					else
						#joined tour
						@tourguide = Tourguide.where(device_id:@device.id).first
						# @tourguide_info = @tourguide
						# @tourguide_info[:abc] = @device.lat
						# @tourguide[:lng] = @device.lng
						unless  @tourguide == nil #tourguide
							#render tourguide info
								render json:{ 
												status:0,message: "Success",details:{
																	group: 1,name_device: @device.name,notification:2,info:{
																		id:@tourguide[:id],
																		name:@tourguide[:name],
																		address:@tourguide[:address],
																		tour_name:@tourguide.tours.first.name,
																		lat:@device.lat == nil ? "" : @device.lat,
																		lng:@device.lng == nil ? "" : @device.lng,
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
													tour_name:@traveller.tours.first.name,
													lat:@device.lat == nil ? "" : @device.lat,
													lng:@device.lng == nil ? "" : @device.lng,
													phone:@traveller[:phone],
													device_id:@device.id
												}
											}
										}
						end
						
					end
				else #don't already system
					#render status = 001
					render json:{status:0,message:"Device not already in system",details:{
																	group: "",name_device:"",notification:0,info:{
																		id:"",
																		name:"",
																		address:"",
																		tour_name:"",
																		lat:"",
																		lng:"",
																		phone:"",
																		device_id:""
																		}
																	}
																}
				end
			else
				render json:{status: 1, message:"Missing device code"}
			end
		end
		#function add device
		def create
			unless params[:company_code] == "" or params[:device_code] == ""
				#check company code
				@check_company = Company.where(code: params[:company_code]).first
				if @check_company
					unless params[:device_code] == ""
						@check_code = Device.where(code:params[:device_code]).first
						if @check_code
							render json:{status: 8, message:"device code already exist"}
						else
							@device = Device.new(name:params[:device_code],code:params[:device_code],company_id:@check_company.id,status:0)
							@device.save
							render json: {status: 0, message:"Success"}
						end
					else
						render json:{status:1,message:"Missing device code"}
					end
				else
					render json:{status: 6,message:"Company code don't exist"}
				end
			else
				 render json:{status:2, message:"Not found information Device or Company.	"}
			end
		end
	# end	
end