# frozen_string_literal: true

# Clase que representa un Client en UCRM.
#
class UCRM::Client < UCRM::UCRMBaseModel
  CLIENT_TYPES = {
    '1': :person,
    '2': :company
  }.freeze

  # IDs definidos en UCRM para los "custom attributes" de clientes
  ATTRIBUTE_ID_DNI = 1
  ATTRIBUTE_ID_CUIT = 2

  # Atributos que están en Maxwell pero no tienen correspondencia en UCRM
  UNMATCHED_ATTRS = %w[id city_id created_at updated_at plan_service_id city_id
                       province_id iva_condition date_of_birth ucrm_id
                       contabilium_id].freeze

  # Mapeo de los atributos de un cliente de Maxwell a un cliente de UCRM
  # @param client [Client] cliente de Maxwell
  # @return [Hash] atributos con el formato como lo espera UCRM
  #
  def self.ucrm_attributes(client)
    {
      id: client.ucrm_id,
      userIdent: client.number.to_s,
      organizationId: client.organization&.ucrm_id,
      countryId: client.country&.ucrm_id,
      zipCode: client.postal_code,
      street1: client.address,
      street2: client.floor_dept,
      note: client.notes,
      contacts: [{
        email: client.email,
        phone: client.phone
      }],
      custom_attributes: [{
        customAttributeId: client.dni? ? ATTRIBUTE_ID_DNI : ATTRIBUTE_ID_CUIT,
        value: client.document_number.to_s
      }]
    }.merge(client_type_attributes(client))
  end

  # Devuelve un Hash con los atributos correspondientes (firstName y lastName)
  # si el cliente es una persona o si es una empresa (companyName).
  # @param client [Client]
  # @return [Hash]
  #
  def self.client_type_attributes(client)
    if client.person?
      { firstName: client.firstname, lastName: client.lastname, clientType: 1 }
    else
      { companyName: client.company_name, clientType: 2 }
    end
  end

  # Construye un cliente de UCRM a partir de un cliente de Maxwell
  # @param client [Client]
  # @return [UCRM::Client]
  #
  def self.from_model(client)
    new(ucrm_attributes(client))
  end

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
    cuit = parse_custom_attribute_number(ATTRIBUTE_ID_CUIT)
    return { document_number: cuit, document_type: 'cuit' } if cuit

    dni = parse_custom_attribute_number(ATTRIBUTE_ID_DNI)
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
