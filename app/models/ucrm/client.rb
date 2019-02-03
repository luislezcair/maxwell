# frozen_string_literal: true

# Clase que representa un Client en UCRM.
#
class UCRM::Client < UCRM::UCRMBaseModel
  CLIENT_TYPES = {
    '1': :person,
    '2': :company
  }.freeze

  UNMATCHED_ATTRS = %w[id city_id created_at updated_at plan_service_id city_id
                       province_id iva_condition date_of_birth ucrm_id
                       contabilium_id].freeze

  def initialize(args)
    super(args)
    @klass = ::Client
    @ucrm_local_id_field = :ucrm_id
  end

  # Cargar los atributos con los valores de la entidad de UCRM.
  #
  def maxwell_model_attributes
    {
      company_name: companyName,
      firstname: firstName,
      lastname: lastName,
      number: userIdent.to_i,
      organization_id: organization,
      client_type: CLIENT_TYPES[clientType],
      country_id: country,
      province_id: province,
      address: street1,
      floor_dept: street2,
      notes: note,
      postal_code: zipCode
    }.merge(contact_information).merge(document_information)
  end

  private

  # Extrae la información de contacto del cliente del arreglo 'contacts'
  #
  def contact_information
    if (c = contacts.first)
      { phone: c['phone']&.gsub(/[^0-9]/, ''), email: c['email'] }
    else
      {}
    end
  end

  def organization
    Organization.find_by(ucrm_id: organizationId)&.id
  end

  # Extrae el CUIT o DNI de un cliente del arreglo `custom_attributes`. Un
  # atributo con ID 1 es el DNI y un atributo con ID 2 es CUIT. Nosotros
  # guardamos solamente uno así que preferimos primero el CUIT.
  #
  def document_information
    cuit = parse_custom_attribute_number(2)
    return { document_number: cuit, document_type: 'cuit' } if cuit

    dni = parse_custom_attribute_number(1)
    return { document_number: dni, document_type: 'dni' } if dni

    {}
  end

  # Buscar el país que corresponde al countryId de UCRM
  #
  def country
    ::Country.find_by(ucrm_id: countryId)&.id
  end

  # UCRM no tiene información sobre la provincia, así que por defecto ponemos
  # Misiones
  #
  def province
    ::Province.find_by(name: 'Misiones')&.id
  end

  # Parsea un custom attribute numérico con id `id`
  # @param id [Integer] valor de la propiedad `customAttributeId` de UCRM.
  #
  def parse_custom_attribute_number(id)
    c = custom_attributes.select { |a| a['customAttributeId'] == id }.first
    return c['value'].gsub(/[^0-9]/, '') if c
  end
end
