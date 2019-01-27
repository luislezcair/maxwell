# frozen_string_literal: true

# Helpers para la vista de invoices
#
module InvoicesHelper
  # Devuelve la URL para ver los detalles de un comprobante en contabilium.
  #
  def contabilium_invoice_link(id)
    return '' if id.blank?

    "#{CONTABILIUM_APP_URL}/comprobantese.aspx?ID=#{id}"
  end

  # Devuelve una URL para ver los detalles de un comprobante en UCRM.
  #
  def ucrm_invoice_link(id)
    return '' if id.blank?

    "#{UCRM_URL}/billing/invoice/#{id}"
  end
end
