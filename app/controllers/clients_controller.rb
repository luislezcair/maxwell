# frozen_string_literal: true

# Controlador para Clientes
#
class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /clients
  def index
    @q = Client.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @clients = @q.result.page(params[:page])
  end

  # GET /clients/search
  def search
    term = params[:term]
    return Client.where('1=0') unless term&.size&.positive?

    @q = Client.synced.accessible_by(current_ability)
               .ransack(identification_cont: term)
    @q.sorts = 'name asc' if @q.sorts.empty?
    @clients = @q.result.limit(50)
  end

  # GET /clients/1
  def show; end

  # GET /clients/1/edit
  def edit; end

  # GET /clients/new
  def new
    @client = Client.new(province_id: default_province,
                         country_id: default_country)
  end

  # POST /clients
  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client
    else
      render :new, alert: :error
    end
  end

  # PUT/PATCH /clients/1
  def update
    if @client.update(client_params)
      redirect_to @client
    else
      render :edit, alert: :error
    end
  end

  # DELETE /clients/1
  def destroy
    destroy_model @client
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client)
          .permit(:address, :city_id, :client_type, :company_name, :country_id,
                  :date_of_birth, :document_number, :document_type, :email,
                  :firstname, :floor_dept, :iva_condition, :lastname, :notes,
                  :number, :organization_id, :phone, :plan_service_id,
                  :postal_code, :province_id)
  end

  # Seleccionamos una provincia por defecto más conveniente para la alta de
  # clientes.
  #
  def default_province
    Province.select(:id).find_by(name: 'Misiones')&.id
  end

  # Seleccionamos un país por defecto más conveniente.
  #
  def default_country
    Country.select(:id).find_by(name: 'Argentina')&.id
  end
end
