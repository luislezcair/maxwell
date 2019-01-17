# frozen_string_literal: true

# Al hacer POST o PATCH a UCRM tenemos que eliminar algunos atributos del cuerpo
# de la solicitud que se envía. Por ahora solo los atributos "id".
#
# TODO:Estos atributos no pueden modificarse:
#   "accountBalance"
#   "accountCredit"
#   "accountOutstanding"
#   "currencyCode"
#   "organizationName"
#   "bankAccounts"
#   "tags"
#   "invitationEmailSentDate"
#   "usesProforma":
#
# Estos atributos son arreglos que tienen un campo Id dentro y ese campo ID no
# está permitido tampoco:
#   "contacts"
#
# A este atributo hay que renombrarlo a 'attributes'.
#   "custom_attributes"
#
class UcrmRequestBuilder < Faraday::Middleware
  IGNORE_ATTRS = [:id].freeze

  def call(env)
    env.body&.delete_if { |key, _| IGNORE_ATTRS.include?(key) }
    @app.call(env)
  end
end
