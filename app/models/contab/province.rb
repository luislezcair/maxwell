# frozen_string_literal: true

# Clase que representa un País en Contabilium.
# Solamente permite hacer GET /common/provincias para obtener la colección
# completa, otros métodos no están disponibles.
#
class Contab::Province < Contab::ContabBaseModel
  collection_path 'common/provincias'

  def self.collection(country_id = 10)
    get "#{collection_path}?idPais=#{country_id}"
  end

  def initialize(args)
    super(args)
    @klass = ::Province
    @contab_local_id_field = :contabilium_id
  end

  # Cargar los atributos con los valores de la entidad de Contabilium
  #
  def maxwell_model_attributes
    { name: self.Nombre }
  end
end
