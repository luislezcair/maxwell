class TechnicalServicesController < ApplicationController
  def index
    @technical_services = TechnicalService.all
  end

  def new
    @technical_service = TechnicalService.new
  end

  def create
    @technical_service = TechnicalService.new(technical_service_params)
    if @technical_service.save
      redirect_to technical_services_url
    else
      render :new, alert: :error
    end
  end

  private

  def technical_service_params
    params.require(:technical_service)
          .permit(:work_order_number)
  end
end
