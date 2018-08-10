# frozen_string_literal: true

# Clase que representa un Client en UCRM.
#
class UCRM::Client < UCRM::UCRMBaseModel
  def initialize(args)
    super(args)
    @klass = ::Client
    @ucrm_local_id_field = :ucrm_id
  end

  # Cargar los atributos con los valores de la entidad de UCRM.
  #
  def maxwell_model_attributes
    { firstname: firstName, lastname: lastName, number: userIdent.to_i }
  end
end
