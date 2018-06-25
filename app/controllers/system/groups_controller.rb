class System::GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /system/groups
  def index
    @q = Group.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @groups = @q.result.page(params[:page])
  end

  # GET /system/groups/new
  def new
    @group = Group.new
  end

  # GET /system/groups/1
  def show; end

  # GET /system/groups/1/edit
  def edit; end

  # POST /system/groups
  def create
    @group = Group.new(group_params)
    if @group.save
      redirect_to @group
    else
      render :new, alert: :error
    end
  end

  # PUT/PATCH /system/groups/1
  def update
    if @group.update(group_params)
      redirect_to @group
    else
      render :edit, alert: :error
    end
  end

  # DELETE /system/groups/1
  def destroy; end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group)
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
