# frozen_string_literal: true

# Controlador para Clientes
#
class ClientsController < ApplicationController
  before_action :authenticate_user!

  # GET /clients/search
  def search
    setup_search

    @clients = @clients.where('1=0') unless search_params? && valid_params?
    @identification_cont = params.dig(:q, :identification_cont)
  end

  private

  def setup_search
    @q = Client.synced.accessible_by(current_ability).ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @clients = @q.result.page(params[:page]).per(10)
  end

  # Buscar solamente si el usuario ingresó 3 o más caracteres para limitar la
  # cantidad de resultados.
  #
  def valid_params?
    id = params.dig(:q, :identification_cont)
    id && id.size > 2
  end
end
