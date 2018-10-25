# frozen_string_literal: true

# Job que se encarga de sincronizar los comprobantes de un BillingExport con
# Contabilium y UCRM.
#
# Este job es idempotente, es decir, puede volver a ejecutarse en caso de error
# ya que solamente intenta sincronizar con uno de los sistemas externos
# si no se sincronizó anteriormente.
#
class InvoiceSyncJob
  include Sidekiq::Worker

  # Método principal llamado por Sidekiq para ejecutar este proceso. Recibe
  # como parámetro el ID del Invoice porque no estamos usando ActiveJobs.
  #
  def perform(invoice_id)
    setup_job(invoice_id)

    @job.set_status_and_save(:working, 'contabilium')
    perform_contabilium_sync if @invoice.contabilium_id.blank?
    @job.set_status_and_save(:finished, 'finished_contabilium')

    # Reboot status and set progress to 0
    @job.set_status_and_save(:working, 'ucrm', 0)
    perform_ucrm_sync if @invoice.ucrm_id.blank?
    @job.set_status_and_save(:finished, 'finished_ucrm')
  end

  protected

  # Sincronización con Contabilium.
  #
  def perform_contabilium_sync
    logger.info("EXPORTING INVOICE #{@invoice.id} TO CONTABILIUM!!!!")

    Contab::Invoice.reload_api
    ci = Contab::Invoice.from_model(@invoice)
    response = ci.save!

    if response.respond_to?(:response_id)
      logger.info("DID IT!!!! CONTAB ID IS #{response.response_id}")
      @invoice.contabilium_id = response.response_id
      @invoice.save!
    else
      error = response.response_errors.first
      logger.info("DAMN!!!, SOME ERROR: #{error}")
      @job.set_status_and_save(:error, nil, nil, error)
    end
  end

  # Sincronización con UCRM.
  #
  def perform_ucrm_sync
    logger.info("EXPORTING INVOICE #{@invoice.id} TO UCRM!!!!")

    ci = UCRM::Invoice.from_model(@invoice)
    response = ci.save!

    if response.id
      logger.info("DID IT!!!! UCRM ID IS #{response.id}")
      @invoice.ucrm_id = response.id
      @invoice.save!
    else
      logger.info('DAMN!!!, SOME ERROR')
    end
  end

  private

  # Busca el Invoice y el BackgroundJob que vamos a utilizar y lo carga
  # a variables de instancia.
  #
  def setup_job(invoice_id)
    @invoice = Invoice.find(invoice_id)
    @job = @invoice.background_job

    logger.info('I AM GOING TO EXPORT ONE INVOICE TO UCRM AND CONTABILIUM')
  end
end
