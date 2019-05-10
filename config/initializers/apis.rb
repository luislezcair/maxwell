# frozen_string_literal: true

# La API que se va a usar se elige de acuerdo al valor de la variable de
# entorno, ya que necesitamos que se utilicen los sistemas de prueba por más
# que el entorno Rails sea de producción (como en Heroku).
#
# Esta variable sólo debería definirse en producción.
#
if ENV['APIS_ENV'] == 'production'
  UCRM_URL = 'https://clientes.ksys.com.ar'
  UCRM_ENV = :production

  CONTABILIUM_ENV = :production
else
  UCRM_URL = 'https://ucrm-testing.ksys.com.ar'
  UCRM_ENV = :development

  CONTABILIUM_ENV = :development
end

UCRM_API_URL = "#{UCRM_URL}/api/v1.0"
CONTABILIUM_APP_URL = 'https://app.contabilium.com'
