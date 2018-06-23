class TechnicalServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_technical_service, only: [:show, :edit, :update, :destroy]

  # GET /technical_services
  def index
    @q = TechnicalService.ransack(params[:q])
    @q.sorts = 'datetime desc' if @q.sorts.empty?
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
  def update
    if @technical_service.update(technical_service_params)
      redirect_to @technical_service
    else
      render :edit, alert: :error
    end
  end

  # DELETE /technical_services/1
  def destroy; end

  private

  def set_technical_service
    @technical_service = TechnicalService.find(params[:id])
  end

  def technical_service_params
    params.require(:technical_service)
          .permit(:work_order_number, :device_id, :client_id, :plan_service_id,
                  :router_model, :router_serial_number,
                  :wifi_ssid, :wifi_password, :arrival_time, :departure_time,
                  :cable_length, :plug_adapter_quantity, :google_maps_url,
                  :labour_cost, :equipment_cost, :observations, :city_id,
                  :ground_wire_setup_type_id, :surge_protector_setup_type_id,
                  :support_type_id, :balancer_id, :transmitter_id, :tower_id,
                  work_type_ids: [], corporate_cellphone_ids: [],
                  technician_ids: [])
  end
end
