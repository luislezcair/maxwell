# frozen_string_literal: true

# Controlador para CRUD de Technicians.
#
class Elements::TechniciansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_technician, only: [:edit, :update, :destroy]
  authorize_resource

  # GET /elements/technicians
  def index
    @q = Technician.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @technicians = @q.result.page(params[:page])
  end

  # GET /elements/technicians/new
  def new
    @technician = Technician.new
  end

  def edit; end

  # POST /elements/technicians
  def create
    @technician = Technician.new(technician_params)
    if @technician.save
      redirect_to elements_technicians_path
    else
      render :new, alert: :error
    end
  end

  # PUT/PATCH /elements/technicians/1
  def update
    if @technician.update(technician_params)
      redirect_to elements_technicians_path
    else
      render :edit, alert: :error
    end
  end

  # DELETE /elements/technicians/1
  def destroy
    destroy_model(@technician)
  end

  private

  def set_technician
    @technician = Technician.find(params[:id])
  end

  def technician_params
    params.require(:technician).permit(:firstname, :lastname, :active)
  end
end
