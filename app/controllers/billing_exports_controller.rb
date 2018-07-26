class BillingExportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_billing_export, only: [:perform, :download_csv,
                                            :job_status]
  authorize_resource
  authorize_resource TechnicalService

  include DateRansacker
  date_param :datetime

  # GET /technical_services
  def index
    search_params = search_params?
    datetimes_for_day if search_params

    @q = TechnicalService.not_billed.ransack(params[:q])
    @q.sorts = 'datetime desc' if @q.sorts.empty?
    @billing_export = BillingExport.new

    # Si no hay parámetros de búsqueda muestra la tabla vacía. Si hay parámetros
    # muestra todos los resultados en una sola página.
    ts = @q.result.page(nil)
    @technical_services = if search_params
                            ts.per(TechnicalService.count)
                          else
                            default_dates
                            ts.where('1=0')
                          end
  end

  # POST /billing_exports
  def create
    @billing_export = BillingExport.new(billing_export_params)
    if @billing_export.save
      render 'create_success'
    else
      render 'create_error'
    end
  end

  # POST /billing_exports/1/perform
  def perform
    @billing_export.perform_sync
  end

  # GET /billing_exports/1/job_status
  def job_status
    @job = @billing_export.background_job
  end

  # TODO: La exportación mediante CSV es para comprobantes ya emitidos por
  # talonario o electrónicamente. Nosotros tenemos que emitir comprobantes del
  # tipo "cotización" que luego se van a emitir realmente en Contabilium.
  #
  # GET /billing_exports/1/download_csv
  def download_csv
    send_data('pending...', filename: @billing_export.filename)
  end

  private

  def set_billing_export
    @billing_export = BillingExport.find(params[:id])
  end

  def search_params?
    params[:q] && params[:q].reject { |_, v| v.blank? }.present?
  end

  def default_dates
    @q.datetime_gteq = Time.current.beginning_of_month
    @q.datetime_lteq = Time.current.end_of_month
  end

  def billing_export_params
    params.require(:billing_export)
          .permit(:export_type, technical_service_ids: [])
  end
end
