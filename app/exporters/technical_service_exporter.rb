# frozen_string_literal: true

# Clase para exportar Technical Services a archivos como Excel, ajustando los
# atributos y las relaciones has_many para acomodarlos en una sola fila.
#
class TechnicalServiceExporter
  EXCEL_MIME_TYPE =
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'

  def initialize(services)
    @services = services
  end

  # Devuelve un arreglo con los nombres de los atributos para una fila de
  # encabezado.
  #
  def attributes
    attrs = %w[organization datetime client city work_order_number plan_service
               technicians arrival_time departure_time work_types labour_cost
               equipment_cost total_cost google_maps_url observations tower
               transmitter device corporate_cellphones router_model
               router_serial_number wifi_ssid wifi_password cable_length
               plug_adapter_quantity balancer support_type
               ground_wire_setup_type surge_protector_setup_type]

    attrs.map do |a|
      I18n.t(".activerecord.attributes.technical_service.#{a}")
    end
  end

  # Devuelve un arreglo con los valores de los atributos en el mismo orden
  # que los encabezados en `attributes`. Convierte las relaciones many-to-many
  # a string concatenando los valores que correspondan.
  #
  def values
    @services.map do |s|
      cellphones = s.corporate_cellphones.map(&:to_label).join('; ')
      technicians = s.technicians.map(&:name).join('; ')
      work_types = s.work_types.pluck(:name).join('; ')
      [
        s.organization.name,
        s.datetime,
        s.client.name,
        s.city.name,
        s.work_order_number,
        s.plan_service.try(:name),
        technicians,
        s.arrival_time,
        s.departure_time,
        work_types,
        s.labour_cost,
        s.equipment_cost,
        s.total_cost,
        s.google_maps_url,
        s.observations,
        s.tower&.name,
        s.transmitter&.name,
        s.device&.model,
        cellphones,
        s.router_model,
        s.router_serial_number,
        s.wifi_ssid,
        s.wifi_password,
        s.cable_length,
        s.plug_adapter_quantity,
        s.balancer&.name,
        s.support_type&.name,
        s.ground_wire_setup_type&.name,
        s.surge_protector_setup_type&.name
      ]
    end
  end

  # Devuelve un arreglo con los formatos de datos para el archivo de Excel.
  # Tienen que tener el mismo orden que `attributes`. Si se coloca nil o se
  # omite el formato queda como string.
  #
  def formats
    [
      nil,
      'DD/MM/YYYY', # datetime
      nil, nil, nil, nil, nil,
      'HH:MM', # arrival_time
      'HH:MM', # departure_time
      nil,
      '[$$-2C0A]#,##0.00;([$$-2C0A]#,##0.00)', # labour_cost
      '[$$-2C0A]#,##0.00;([$$-2C0A]#,##0.00)', # equipment_cost
      '[$$-2C0A]#,##0.00;([$$-2C0A]#,##0.00)' # total_cost
    ]
  end

  def model_name
    I18n.t('activerecord.models.technical_service', count: 2)
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

      sheet.auto_filter = 'A1:AC1'
    end

    p.to_stream
  end
end
