# frozen_string_literal: true

# Clase que representa un País en Contabilium.
# Solamente permite hacer GET /common/paises para obtener la colección completa,
# otros métodos no están disponibles.
#
class Contab::Country < Contab::ContabBaseModel
  collection_path 'common/paises'

  def initialize(args)
    super(args)
    @klass = ::Country
    @contab_local_id_field = :contabilium_id
  end

  # Cargar los atributos con los valores de la entidad de Contabilium
  #
  def maxwell_model_attributes
    { name: self.Nombre }
  end
end
