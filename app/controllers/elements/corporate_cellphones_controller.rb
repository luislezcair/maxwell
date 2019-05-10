# frozen_string_literal: true

# Controlador para CRUD de CorporateCellphones
#
class Elements::CorporateCellphonesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_corporate_cellphone, only: [:edit, :update, :destroy]
  authorize_resource

  # GET /elements/corporate_cellphones
  def index
    @q = CorporateCellphone.ransack(params[:q])
    @q.sorts = 'phone asc' if @q.sorts.empty?
    @cellphones = @q.result.page(params[:page])
  end

  # GET /elements/corporate_cellphones/new
  def new
    @cellphone = CorporateCellphone.new
  end

  def edit; end

  # POST /elements/corporate_cellphones
  def create
    @cellphone = CorporateCellphone.new(corporate_cellphone_params)
    if @cellphone.save
      redirect_to elements_corporate_cellphones_path
    else
      render :new, alert: :error
    end
  end

  # PUT/PATCH /elements/corporate_cellphones/1
  def update
    if @cellphone.update(corporate_cellphone_params)
      redirect_to elements_corporate_cellphones_path
    else
      render :edit, alert: :error
    end
  end

  # DELETE /elements/corporate_cellphones/1
  def destroy
    destroy_model(@cellphone)
  end

  private

  def set_corporate_cellphone
    @cellphone = CorporateCellphone.find(params[:id])
  end

  def corporate_cellphone_params
    params.require(:corporate_cellphone).permit(:phone)
  end
end
