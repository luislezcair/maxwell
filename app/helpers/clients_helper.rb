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
    number = t('activerecord.attributes.client.number')
    "#{cli.name} - (#{number}: #{cli.number}) - (#{id}: #{cuit_dni(cli)})"
  end
end
