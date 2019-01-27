# frozen_string_literal: true

# Módulo con helpers utilizados en toda la aplicación.
#
module ClientsHelper
  # Da formato al DNI o CUIT de un cliente.
  # DNI: 12345678 -> 12.345.678
  # CUIT: 12345678901 -> 12-34567890-1
  #
  def cuit_dni(client)
    n = client.document_number.to_s
    if client.dni?
      number_with_delimiter(n)
    else
      "#{n[0..1]}-#{n[2..9]}-#{n[10..11]}"
    end
  end

  # Devuelve una descripción del cliente que incluye nombre, CUIT o DNI y código
  # de cliente.
  #
  def client_label(cli)
    return unless cli

    id = cli.dni? ? 'DNI' : 'CUIT'
    number = I18n.t('activerecord.attributes.client.number_short')
    "#{cli.name} - (#{number}: #{cli.number}) - (#{id}: #{cuit_dni(cli)})"
  end

  # Da formato de teléfono al número pasado como parámetro: (xxxx) xxx xxx
  #
  def phone_format(phone)
    number_to_phone(phone, area_code: true, delimiter: ' ',
                           pattern: /(\d{4})(\d{3})(\d{3})$/)
  end

  # Devuelve la URL para ver los detalles de un cliente en contabilium.
  #
  def contabilium_client_link(id)
    return '' if id.blank?

    "#{CONTABILIUM_APP_URL}/personase.aspx?ID=#{id}&tipo=c"
  end

  # Devuelve una URL para ver los detalles de un cliente en UCRM.
  #
  def ucrm_client_link(id)
    return '' if id.blank?

    "#{UCRM_URL}/client/#{id}"
  end

  # Si el usuario pertenece a una organización, devuelve una colección con una
  # única Organization como elemento, que es la organización del usuario actual.
  # Si no pertenece a ninguna, se devuelve una colección con todas las
  # organizaciones
  #
  def accessible_organizations
    if current_user.group.organization
      Organization.where(id: current_user.group.organization_id)
    else
      sorted_organizations
    end
  end
end
