# frozen_string_literal: true

# Clase que representa una Torre (Tower) en UCRM (Site).
#
class UCRM::Site < UCRM::UCRMBaseModel
  def initialize(args)
    super(args)
    @klass = Tower
    @ucrm_local_id_field = :ucrm_site_id
  end

  # Cargar los atributos con los valores de la entidad de UCRM.
  #
  def maxwell_model_attributes
    { name: name, address: address, gps_lat: gpsLat, gps_lon: gpsLon,
      notes: notes, contact_info: contactInfo }
  end
end
