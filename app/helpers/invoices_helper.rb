# frozen_string_literal: true

# Helpers para la vista de invoices
#
module InvoicesHelper
  def contabilium_link(invoice)
    return '' if invoice.contabilium_id.blank?
    "#{CONTABILIUM_APP_URL}/comprobantese.aspx?ID=#{invoice.contabilium_id}"
  end

  def ucrm_link(invoice)
    return '' if invoice.ucrm_id.blank?
    "#{UCRM_URL}/billing/invoice/#{invoice.ucrm_id}"
  end
end
