# frozen_string_literal: true

# Clase que representa un Device (Antenna) en UCRM (Device).
#
class UCRM::ServicePlan < UCRM::UCRMBaseModel
  collection_path 'service-plans'

  def initialize(args)
    super(args)
    @klass = ::PlanService
    @ucrm_local_id_field = :ucrm_plan_service_id
  end

  # Cargar los atributos con los valores de la entidad de UCRM.
  #
  def maxwell_model_attributes
    { name: name }
  end
end
