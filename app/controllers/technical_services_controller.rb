class TechnicalServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_technical_service, only: [:show, :edit, :update, :destroy]

  # GET /technical_services
  def index
    @q = TechnicalService.ransack(params[:q])
    @technical_services = @q.result.page(params[:page])
  end

  # GET /technical_services/new
  def new
    @technical_service = TechnicalService.new
  end

  # GET /technical_services/1
  def show; end

  # GET /technical_services/1/edit
  def edit; end

  # POST /technical_services
  def create
    @technical_service = TechnicalService.new(technical_service_params)
    if @technical_service.save
      redirect_to @technical_service
    else
      render :new, alert: :error
    end
  end

  # PUT/PATCH /technical_services/1
  def update; end

  # DELETE /technical_services/1
  def destroy; end

  private

  def set_technical_service
    @technical_service = TechnicalService.find(params[:id])
  end

  def technical_service_params
    params.require(:technical_service)
          .permit(:work_order_number, :antenna_serial_number, :antenna_model,
                  :antenna_ip_address, :router_model, :router_serial_number,
                  :wifi_ssid, :wifi_password, :arrival_time, :departure_time,
                  :cable_length, :plug_adapter_quantity, :google_maps_url,
                  :labour_cost, :equipment_cost, :observations)
  end
end
