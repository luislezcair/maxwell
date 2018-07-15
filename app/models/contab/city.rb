# frozen_string_literal: true

# Clase que representa una ciudad en Contabilium.
# Solamente permite hacer GET /common/ciudades para obtener la colección
# completa, otros métodos no están disponibles.
#
class Contab::City < Contab::ContabBaseModel
  collection_path 'common/ciudades'

  def self.collection(province_id = 2)
    get "#{collection_path}?idProvincia=#{province_id}"
  end

  def initialize(args)
    super(args)
    @klass = ::City
    @contab_local_id_field = :contabilium_id
  end

  # Cargar los atributos con los valores de la entidad de Contabilium
  #
  def maxwell_model_attributes
    { name: self.Nombre }
  end
end
