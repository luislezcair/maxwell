# frozen_string_literal: true

# Clase que representa un Cliente en Contabilium.
#
class Contab::Client < Contab::ContabBaseModel
  collection_path 'clientes'

  # Método para obtener la colección de clientes. Contabilium requiere los
  # parámetros `filtro` y `page` y, además, la colección se obtiene con
  # GET /clientes/search.
  #
  def self.collection(page = 1, filter = nil)
    get("#{collection_path}/search?filtro=#{filter}&page=#{page}")
  end

  def initialize(args)
    super(args)
    @klass = ::Client
    @contab_local_id_field = :contabilium_id
  end

  # Cargar los atributos con los valores de la entidad de UCRM.
  # TODO: WIP
  #
  def maxwell_model_attributes; end

  private

  # Dividir la razón social en dos nombres cuando `personeria` es F (Física).
  #
  def names_from_social_reason; end

  # Convertir la condición de IVA a los códigos usados por Maxwell.
  #
  def iva_condition; end

  # Devuelve el tipo de cliente de acuerdo a la `personeria` de Contabilium.
  #
  def client_type; end

  # Buscar el país que corresponde al idPais de Contabilium
  #
  def country; end

  def province; end

  def city; end
end
