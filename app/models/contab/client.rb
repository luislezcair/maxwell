# frozen_string_literal: true

# Clase que representa un Cliente en Contabilium.
#
class Contab::Client < Contab::ContabBaseModel
  collection_path 'clientes'
  primary_key :Id

  # Mapa entre las condiciones de IVA de Contabilium y Maxwell
  IVA_CONDITIONS = {
    'CF': :consumidor_final,
    'RI': :responsable_inscripto,
    'EX': :excento,
    'MO': :monotributista
  }.freeze

  # Mapa entre los tipos de document de Contabilium y Maxwell
  DOC_TYPES = {
    'DNI': :dni,
    'CUIT': :cuit
  }.freeze

  CLIENT_TYPES = {
    'F': :person,
    'J': :company
  }.freeze

  # Sobreescribe el método de Contab::ContabBaseModel para indicar que esta
  # colección se consulta por páginas.
  #
  def self.pageable?
    true
  end

  # Método para obtener la colección de clientes. Contabilium requiere los
  # parámetros `filtro` y `page` y, además, la colección se obtiene con
  # GET /clientes/search.
  #
  def self.collection(page = 1, filter = nil)
    get("#{collection_path}/search?filtro=#{filter}&page=#{page}")
  end

  # Mapeo inverso de los atributos de un Client a un Contab::Client.
  #
  def self.contab_attributes(client)
    { RazonSocial: client.name,
      NroDoc: client.document_number,
      Telefono: client.phone,
      Email: client.email,
      Domicilio: client.address,
      PisoDepto: client.floor_dept,
      Cp: client.postal_code,
      Observaciones: client.notes,
      Codigo: client.number,
      Personeria: CLIENT_TYPES.invert[client.client_type.to_sym].to_s,
      CondicionIva: IVA_CONDITIONS.invert[client.iva_condition.to_sym].to_s,
      TipoDoc: DOC_TYPES.invert[client.document_type.to_sym].to_s,
      IdPais: client.country.contabilium_id,
      IdProvincia: client.province.contabilium_id,
      IdCiudad: client.city&.contabilium_id }
  end

  # Construye un Cliente de Contabilium con los datos de un cliente de Maxwell.
  #
  def self.from_model(client)
    new(contab_attributes(client))
  end

  # Devuelve un arreglo con los atributos necesarios para exportar un cliente a
  # CSV ordenados según los requerimientos de Contabilium.
  #
  def self.csv_attributes(client)
    attrs = contab_attributes(client).merge(csv_extra_attributes(client))
    attrs.fetch_values(:RazonSocial, :fantasy_name, :Email, :TipoDoc, :NroDoc,
                       :CondicionIva, :province, :city, :Domicilio, :web)
  end

  def initialize(args)
    super(args)
    @klass = ::Client
    @contab_local_id_field = :contabilium_id
    @pageable = true
  end

  # Cargar los atributos con los valores de la entidad de Contabilium.
  #
  def maxwell_model_attributes
    attrs = basic_attributes

    if attrs[:client_type] == :person
      attrs.merge!(names_from_social_reason)
    else
      attrs[:company_name] = self.RazonSocial
    end

    attrs
  end

  private

  def basic_attributes
    { client_type: client_type,
      iva_condition: iva_condition,
      document_type: doc_type,
      document_number: self.NroDoc.to_i,
      phone: self.Telefono,
      email: self.Email,
      address: self.Domicilio,
      floor_dept: self.PisoDepto,
      postal_code: self.Cp,
      notes: self.Observaciones,
      number: self.Codigo.to_i,
      country: country,
      province: province,
      city: city }
  end

  # Dividir la razón social en dos nombres cuando `personeria` es F (Física).
  #
  def names_from_social_reason
    names = self.RazonSocial.strip.delete(',').split(' ', 2)
    lastname = names.one? ? 'SIN APELLIDO' : names.second

    { firstname: names.first, lastname: lastname }
  end

  # Convertir la condición de IVA a los códigos usados por Maxwell.
  #
  def iva_condition
    IVA_CONDITIONS[self.CondicionIva.to_sym]
  end

  # Convertir el tipo de documento (CUIT o DNI) a los tipos usados por Maxwell
  #
  def doc_type
    DOC_TYPES[self.TipoDoc.to_sym]
  end

  # Devuelve el tipo de cliente de acuerdo a la `personeria` de Contabilium.
  # J -> Jurídica -> :company
  # F -> Física -> :person
  #
  def client_type
    CLIENT_TYPES[self.Personeria.to_sym]
  end

  # Buscar el país que corresponde al idPais de Contabilium
  #
  def country
    ::Country.find_by(contabilium_id: self.IdPais)
  end

  # Buscar la provincia que corresponde al IdProvincia de Contabilium
  #
  def province
    ::Province.find_by(contabilium_id: self.IdProvincia)
  end

  # Busca la ciudad que corresponde al IdCiudad de Contabilium [opcional].
  #
  def city
    ::City.find_by(contabilium_id: self.IdCiudad)
  end
end
