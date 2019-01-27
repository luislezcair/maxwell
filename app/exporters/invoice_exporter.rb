# frozen_string_literal: true

# Clase para exportar Invoices a archivos como Excel, ajustando los
# atributos y las relaciones has_many para acomodarlos en una sola fila.
#
class InvoiceExporter
  include InvoicesHelper

  EXCEL_MIME_TYPE =
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'

  def initialize(invoices)
    @invoices = invoices
  end

  # Devuelve un arreglo con los nombres de los atributos para una fila de
  # encabezado.
  #
  def attributes
    attrs = %w[emission_date expiry_date client voucher_type sale_condition
               net_amount iva_amount total_amount ucrm contabilium notes]

    attrs.map do |a|
      I18n.t(".activerecord.attributes.invoice.#{a}")
    end
  end

  # Devuelve un arreglo con los valores de los atributos en el mismo orden
  # que los encabezados en `attributes`. Convierte las relaciones many-to-many
  # a string concatenando los valores que correspondan.
  #
  def values
    @invoices.map do |i|
      [
        i.emission_date,
        i.expiry_date,
        i.client.name,
        i.voucher_type_text,
        i.sale_condition_text,
        i.net_amount,
        i.iva_amount,
        i.total_amount,
        ucrm_invoice_link(i.ucrm_id),
        contabilium_invoice_link(i.contabilium_id),
        i.notes
      ]
    end
  end

  # Devuelve un arreglo con los formatos de datos para el archivo de Excel.
  # Tienen que tener el mismo orden que `attributes`. Si se coloca nil o se
  # omite el formato queda como string.
  #
  def formats
    [
      'DD/MM/YYYY',
      'DD/MM/YYYY',
      nil, nil, nil,
      '[$$-2C0A]#,##0.00;([$$-2C0A]#,##0.00)', # net_amount
      '[$$-2C0A]#,##0.00;([$$-2C0A]#,##0.00)', # iva_amount
      '[$$-2C0A]#,##0.00;([$$-2C0A]#,##0.00)' # total_amount
    ]
  end

  def model_name
    I18n.t('activerecord.models.invoice', count: 2)
  end

  def filename
    model_name.gsub(/\s/, '_').downcase
  end

  # Genera un archivo de Excel y devuelve un Stream para leerlo. No se guarda
  # en el sistema de archivos.
  #
  def to_excel_workbook
    p = Axlsx::Package.new
    wb = p.workbook
    styles = formats.map { |f| wb.styles.add_style(format_code: f) }

    wb.add_worksheet(name: model_name) do |sheet|
      sheet.add_row attributes

      values.each do |v|
        sheet.add_row v, style: styles
      end

      sheet.auto_filter = 'A1:K1'
    end

    p.to_stream
  end
end
