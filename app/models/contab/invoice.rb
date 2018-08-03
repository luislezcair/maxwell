# frozen_string_literal: true

# Representa un Comprobante de Contabilium. Esta clase se utiliza para convertir
# entre comprobantes de Maxwell y de Contabilium.
#
class Contab::Invoice < Contab::ContabBaseModel
  collection_path 'comprobantes'
  primary_key :Id

  VOUCHER_TYPES = {
    'FCA': :factura_a,
    'FCB': :factura_b,
    'FCC': :factura_c,
    'NDA': :ndebito_a,
    'NDB': :ndebito_b,
    'NDC': :ndebito_c,
    'NCA': :ncredito_a,
    'NCB': :ncredito_b,
    'NCC': :ncredito_c,
    'COT': :cotizacion
  }.freeze

  SALE_CONDITIONS = {
    'Efectivo': :efectivo,
    'Cheque': :cheque,
    'Cuenta corriente': :cta_cte,
    'MercadoPago': :mercado_pago,
    'PayU': :pay_u,
    'Tarjeta de credito': :credito,
    'Tarjeta de debito': :debito,
    'Ticket': :ticket,
    'Otro': :otro
  }.freeze

  MODES = {
    'O': :other,
    'E': :electronic,
    'T': :checkbook
  }.freeze

  # Esta colección usa paginación
  #
  def self.pageable?
    true
  end

  # Método para obtener la colección de comprobantes. Contabilium requiere los
  # parámetros `filtro` y `page` y, además, la colección se obtiene con
  # GET /comprobantes/search, igual que clientes. Además, permite los parámetros
  # opcionales `fechaDesde` y `fechaHasta` en formato yyyy-MM-dd.
  #
  def self.collection(page = 1, filter = nil, date_start = nil, date_end = nil)
    # TODO: formato de las fechas debe ser yyyy-MM-dd
    url = "#{collection_path}/search?filtro=#{filter}&page=#{page}"
    url = "#{url}&fechaDesde=#{date_start}" if date_start
    url = "#{url}&fechaHasta=#{date_end}" if date_end
    get(url)
  end

  # Devuelve un Hash con los atributos de Contabilium con los valores del
  # Invoice de Maxwell `invoice`.
  #
  def self.contab_attributes(invoice)
    voucher_type = VOUCHER_TYPES.invert[invoice.voucher_type.to_sym].to_s
    sale_point = SystemConfiguration.get_api_config('invoice.point_of_sale_id')
    mode = MODES.invert[invoice.mode.to_sym].to_s
    sale_condition = SALE_CONDITIONS.invert[invoice.sale_condition.to_sym].to_s

    { IdCliente: invoice.client.contabilium_id,
      TipoFc: voucher_type,
      PuntoVenta: sale_point,
      Modo: mode,
      CondicionVenta: sale_condition,
      FechaEmision: invoice.emission_date.iso8601,
      FechaVencimiento: invoice.expiry_date.iso8601,
      Observaciones: invoice.notes,
      Items: build_invoice_items(invoice.invoice_items) }
  end

  # El arreglo de items en realidad debe ser un Hash con la forma:
  # { 0 => { att1: val1, att2: val2 }, 1 => { att1: val1, att2: val2 } }
  # El PrecioUnitario debe ser el monto neto (sin IVA).
  # El IdPlanDeCuenta es el código de la cuenta en el plan de cuentas, no el Id.
  #
  def self.build_invoice_items(items)
    arr = {}
    concept_id = SystemConfiguration.get_api_config('invoice.concept_id')
    account_id = SystemConfiguration.get_api_config('invoice.account_code')

    items.each_with_index do |item, index|
      arr[index.to_s] = {
        Cantidad: item.quantity,
        Concepto: item.description,
        IdConcepto: concept_id,
        IdPlanDeCuenta: account_id,
        PrecioUnitario: item.net_amount.to_f,
        Iva: item.iva_value * 100,
        Bonificacion: item.discount
      }
    end
    arr
  end

  # Crea un Comprobante de Contabilium a partir del Invoice de Maxwell `invoice`
  #
  def self.from_model(invoice)
    new(contab_attributes(invoice))
  end

  # Devuelve un arreglo con los atributos necesarios para exportar un cliente a
  # CSV ordenados según los requerimientos de Contabilium.
  #
  # TODO: La importación mediante CSV a Contabilium es solamente para facturas
  # ya emitidas (por talonario o electrónicas).
  #
  def self.csv_attributes(_invoice); end

  def initialize(args)
    super(args)
    @klass = ::Invoice
    @contab_local_id_field = :contabilium_id
  end

  # Otra vez la gente inteligente de Contabilium. Los comprobantes se crean
  # haciendo POST a /comprobantes/crear y no a /comprobantes como debería.
  # Por qué? No hay por qué
  #
  def save!
    self.class.post("#{self.class.collection_path}/crear", attributes)
  end

  # Devuelve un Hash con los atributos de Maxwell con los valores del
  # Comprobante de Contabilium.
  # TODO: not needed for now.
  #
  def maxwell_model_attributes; end
end
