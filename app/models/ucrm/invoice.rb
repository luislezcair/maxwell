# frozen_string_literal: true

# Clase que representa un Invoice en UCRM.
# El POST debe hacerse a /clients/:client_id/invoices
# El GET es en /invoices/:invoice_id
#
class UCRM::Invoice < UCRM::UCRMBaseModel
  # Una nota que se coloca en el Invoice de UCRM y solo lo puede ver un usuario
  # admin.
  #
  def self.admin_note
    date = I18n.l(Time.current, format: :short_datetime)
    I18n.t('.invoicing.ucrm_admin_note', date: date)
  end

  # GET en /invoices/:invoice_id
  #
  def self.find(invoice_id)
    get("invoices/#{invoice_id.to_i}")
  end

  # Devuelve un Hash con los atributos de UCRM establecidos con los valores de
  # un Invoice de Maxwell.
  #
  def self.ucrm_attributes(invoice)
    days = SystemConfiguration.get_api_config('invoice.expiry_days').to_i
    {
      clientId: invoice.client.ucrm_id,
      createdDate: invoice.emission_date.iso8601,
      maturityDays: days,
      notes: invoice.notes,
      items: build_invoice_items(invoice.invoice_items),
      adminNotes: admin_note
    }
  end

  # Construye un arreglo con el formato de items requerido por UCRM con los
  # InvoiceItems pasados como parámetros.
  #
  def self.build_invoice_items(items)
    items.map do |item|
      {
        label: item.description,
        price: item.amount.to_f,
        quantity: item.quantity
      }
    end
  end

  # Crea un comprobante de UCRM a partir de un Invoice de Maxwell.
  #
  def self.from_model(invoice)
    new(ucrm_attributes(invoice))
  end

  def initialize(args)
    super(args)
    @klass = ::Invoice
    @ucrm_local_id_field = :ucrm_id
  end

  # POST a /clients/:client:id/invoices
  #
  def save!
    new_attributes = attributes.except(:clientId)
    self.class.post("clients/#{attributes[:clientId]}/invoices", new_attributes)
  end

  # Cargar los atributos con los valores de la entidad de UCRM.
  #
  def maxwell_model_attributes; end
end
