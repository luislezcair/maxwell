# frozen_string_literal: true

# Modelo que guarda un Token de autenticación de Contabilium y la fecha de
# expiración.
# Contabilium devuelve un Token válido por 24 horas, por eso lo guardamos y
# cuando se realiza una nueva solicitud a la API, utilizamos el útlimo Token si
# todavía es válido.
#
class AuthToken < ApplicationRecord
  validates :token, :expiration_date, presence: true

  # Crea un nuevo AuthToken con los parámetros recibidos como respuesta de la
  # API: token y cantidad de segundos de validez. Por el momento son 84000
  # segundos o un día.
  #
  # @param [String] token el token recibido de la API
  # @param [FixNum] expires_at fecha en formato UNIX (seconds since epoch) hasta
  # la expiración del token.
  #
  def self.create_from_response(token, expires_at)
    AuthToken.create(token: token, expiration_date: Time.at(expires_at).utc)
  end

  # Obtiene el token cuya fecha de expiración sea la más distante.
  #
  def self.last_token
    max_token = AuthToken.maximum(:expiration_date)
    AuthToken.find_by(expiration_date: max_token)
  end

  # Devuelve true si el token es todavía válido durante el próximo minuto,
  # tiempo suficiente para hacer una consulta al web service.
  #
  def still_valid?
    expiration_date > Time.current.advance(seconds: 60)
  end
end
