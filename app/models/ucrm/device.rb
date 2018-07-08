# frozen_string_literal: true

# Clase que representa un Device (Antenna) en UCRM (Device).
#
class UCRM::Device < UCRM::UCRMBaseModel
  def initialize(args)
    super(args)
    @klass = ::Device
    @ucrm_local_id_field = :ucrm_device_id
  end

  # Cargar los atributos con los valores de la entidad de UCRM.
  #
  def maxwell_model_attributes
    { model: name }
  end
end
