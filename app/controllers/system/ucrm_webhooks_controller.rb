# frozen_string_literal: true

# Controlador para recibir los webhooks desde UCRM
#
class System::UcrmWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:incoming]

  # POST /system/ucrm_webhooks
  def incoming
    @webhook = UcrmWebhook.from_json(params)

    @webhook.launch_action if @webhook.save

    respond_to do |format|
      format.json { head :ok }
    end
  end
end
