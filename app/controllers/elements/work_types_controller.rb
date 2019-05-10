# frozen_string_literal: true

# Controlador para CRUD de WorkTypes.
#
class Elements::WorkTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work_type, only: [:edit, :update, :destroy]
  authorize_resource

  # GET /elements/work_types
  def index
    @q = WorkType.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @work_types = @q.result.page(params[:page])
  end

  # GET /elements/work_types/new
  def new
    @work_type = WorkType.new
  end

  def edit; end

  # POST /elements/work_types
  def create
    @work_type = WorkType.new(work_type_params)
    if @work_type.save
      redirect_to elements_work_types_path
    else
      render :new, alert: :error
    end
  end

  # PUT/PATCH /elements/work_types/1
  def update
    if @work_type.update(work_type_params)
      redirect_to elements_work_types_path
    else
      render :edit, alert: :error
    end
  end

  # DELETE /elements/work_types/1
  def destroy
    destroy_model(@work_type)
  end

  private

  def set_work_type
    @work_type = WorkType.find(params[:id])
  end

  def work_type_params
    params.require(:work_type).permit(:name)
  end
end
