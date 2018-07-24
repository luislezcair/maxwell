# frozen_string_literal: true

# Job que se encarga de sincronizar los comprobantes de un BillingExport con
# Contabilium y UCRM.
#
# Este job es idempotente, es decir, puede volver a ejecutarse en caso de error
# ya que solamente intenta sincronizar aquellas Invoices que todavía no estén
# sincronizadas (que tengan el campo contabilium_id o ucrm_id en nulo).
#
class InvoiceSyncJob
  include Sidekiq::Worker

  # Método principal llamado por Sidekiq para ejecutar este proceso. Recibe
  # como parámetro el ID del BillingExport porque no estamos usando ActiveJobs.
  #
  def perform(billing_export_id)
    setup_job(billing_export_id)

    @job.set_status_and_save(:working, 'syncing_contabilium')
    perform_contabilium_sync
    @job.set_status_and_save(:finished, 'finished_contabilium')

    # Reboot status and set progress to 0
    @job.set_status_and_save(:working, 'syncing_ucrm', 0)
    perform_ucrm_sync
    @job.set_status_and_save(:finished, 'finished_ucrm')
  end

  protected

  # Sincronización con Contabilium de todos los invoices pendientes.
  #
  def perform_contabilium_sync
    @billing_export.invoices.not_synced_contabilium.find_each do |invoice|
      logger.info("EXPORTING INVOICE #{invoice.id} TO CONTABILIUM!!!!")

      ci = Contab::Invoice.from_model(invoice)
      response = ci.save!

      if response.response_id
        logger.info("DID IT!!!! CONTAB ID IS #{response.response_id}")
        invoice.contabilium_id = response.response_id
        invoice.save!
      else
        logger.info('DAMN!!!, SOME ERROR')
      end

      @job.progress += 1
      @job.save!
    end
  end

  # Sincronización con UCRM de todos los invoices pendientes.
  #
  def perform_ucrm_sync
    @billing_export.invoices.not_synced_ucrm.find_each do |invoice|
      logger.info("EXPORTING INVOICE #{invoice.id} TO UCRM!!!!")

      ci = UCRM::Invoice.from_model(invoice)
      response = ci.save!

      if response.id
        logger.info("DID IT!!!! UCRM ID IS #{response.id}")
        invoice.ucrm_id = response.id
        invoice.save!
      else
        logger.info('DAMN!!!, SOME ERROR')
      end

      @job.progress += 1
      @job.save!
    end
  end

  private

  # Busca el BillingExport y el BackgroundJob que vamos a utilizar y lo carga
  # a variables de instancia.
  #
  def setup_job(billing_export_id)
    @billing_export = BillingExport.find(billing_export_id)
    @job = @billing_export.background_job

    count_c = @billing_export.invoices.not_synced_contabilium.count
    count_u = @billing_export.invoices.not_synced_ucrm.count
    logger.info("I AM GOING TO EXPORT #{count_c} INVOICES TO CONTABILIUM AND "\
                "#{count_u} INVOICES TO UCRM")
  end
end
