# frozen_string_literal: true

# Controlador para Invoices
#
class InvoicesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invoice, only: [:show, :perform_sync, :job_status]

  # Utilizar los mismos permisos que BillingExport
  authorize_resource BillingExport

  include DateRansacker
  date_param :emission_date

  # GET /invoices
  def index
    setup_search
    @invoices = @q.result.page(params[:page])
  end

  # GET /invoices/1
  def show; end

  # POST /invoices/1/perform_sync
  def perform_sync
    @invoice.perform_sync
  end

  # GET /invoices/1/job_status
  def job_status
    @job = @invoice.background_job
  end

  # GET /invoices/download
  def download
    setup_search
    @invoices = @q.result

    exporter = InvoiceExporter.new(@invoices)

    send_data exporter.to_excel_workbook.read,
              filename: "#{exporter.filename}.xlsx",
              type: InvoiceExporter::EXCEL_MIME_TYPE
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def setup_search
    datetimes_for_day if search_params? && dates_present?

    @q = Invoice.ransack(params[:q])
    @q.sorts = 'emission_date desc' if @q.sorts.empty?
  end

  def dates_present?
    q = params[:q]
    q[:emission_date_gteq].present? && q[:emission_date_lteq].present?
  end
end
