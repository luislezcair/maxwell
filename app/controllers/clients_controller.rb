# frozen_string_literal: true

# Controlador para Clientes
#
class ClientsController < ApplicationController
  before_action :authenticate_user!

  # GET /clients/search
  def search
    @q = Client.synced.accessible_by(current_ability)
               .ransack(identification_cont: params[:term])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @clients = @q.result

    @clients = @clients.where('1=0') unless valid_params?
  end

  private

  # Buscar solamente si el usuario ingresó 3 o más caracteres para limitar la
  # cantidad de resultados.
  #
  def valid_params?
    id = params[:term]
    id && id.size > 2
  end
end
