# frozen_string_literal: true

# Controlador para Servicios Técnicos
#
class TechnicalServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_technical_service, only: [:show, :edit, :update, :destroy]
  authorize_resource

  include DateRansacker
  date_param :datetime

  # GET /technical_services
  def index
    setup_search
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
    @technical_service.user = current_user
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
  def destroy
    destroy_model(@technical_service)
  end

  # GET /technical_services/download
  def download
    setup_search
    @technical_services = @q.result

    exp = TechnicalServiceExporter.new(@technical_services)

    send_data exp.to_excel_workbook.read,
              filename: "#{exp.filename}.xlsx",
              type: TechnicalServiceExporter::EXCEL_MIME_TYPE
  end

  private

  # Configura los parámetros de búsqueda para Ransack. El campo tipo de costo
  # es especial y se tiene que trasformar a una condicón == 0 o >= 0.
  # Las fechas vienen en formato dd/mm/yyyy. Para utilizarlas en la consulta a
  # la BD hay que agregarles la hora de principio del día y fin del día.
  #
  def setup_search
    if search_params?
      datetimes_for_day if dates_present?
      setup_cost_types if total_cost_type_present?
    end

    @q = TechnicalService.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = ['date desc', 'client_name asc'] if @q.sorts.empty?
  end

  def dates_present?
    q = params[:q]
    q[:datetime_gteq].present? && q[:datetime_lteq].present?
  end

  def total_cost_type_present?
    params[:q][:total_cost_eq].present?
  end

  # total_cost_eq == 1 => Bonificados => total_cost_eq = 0.0
  # total_cost_eq == 2 => No Bonificados => total_cost_gt = 0.0
  #
  def setup_cost_types
    q = params[:q]
    t = q[:total_cost_eq].to_i

    if t == TechnicalServicesHelper::COST_TYPE_FREE
      q[:total_cost_eq] = '0.0'
    elsif t == TechnicalServicesHelper::COST_TYPE_NONFREE
      q[:total_cost_gt] = '0.0'
      q.delete(:total_cost_eq)
    end
  end

  def set_technical_service
    @technical_service =
      TechnicalService.accessible_by(current_ability).find(params[:id])
  end

  def technical_service_params
    attrs = [:work_order_number, :device_id, :client_id, :plan_service_id,
             :router_model, :router_serial_number, :transmitter_id, :tower_id,
             :wifi_ssid, :wifi_password, :arrival_time, :departure_time,
             :cable_length, :plug_adapter_quantity, :google_maps_url,
             :labour_cost, :equipment_cost, :observations, :city_id,
             :ground_wire_setup_type_id, :surge_protector_setup_type_id,
             :support_type_id, :balancer_id,
             work_type_ids: [], corporate_cellphone_ids: [], technician_ids: []]

    # Permitir modificar la fecha solamente si tiene permisio de edición
    attrs << :datetime if can? :edit, TechnicalService
    params.require(:technical_service).permit(attrs)
  end
end
