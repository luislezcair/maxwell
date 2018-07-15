# frozen_string_literal: true

# Clase que representa un País en UCRM.
#
class UCRM::Country < UCRM::UCRMBaseModel
  def initialize(args)
    super(args)
    @klass = ::Country
    @ucrm_local_id_field = :ucrm_id
  end

  # Cargar los atributos con los valores de la entidad de Contabilium
  #
  def maxwell_model_attributes
    { name: name, code: code }
  end
end
