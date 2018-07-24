# frozen_string_literal: true

# Hay reportes que tienen la opción de seleccionar un frecuencia: diaria,
# mensual o anual. Esto hace que las fechas o períodos sean pasados al
# controlador con distintos formatos: "dd/mm/yyyy", "mm/yyyy" y "yyyy".
# Este módulo toma los dos últimos formatos desde los parámetros de Ransack y
# los transforma al formato "dd/mm/yyyy" para que se puedan utilizar en las
# consultas a la base de datos.
#
# Para frecuencia mensual toma el primer día y el último día del mes y para la
# frecuencia anual toma el primer y útlimo día del año.
#
module DateRansacker
  extend ActiveSupport::Concern

  included do
    private

    ##
    # Cuando es un campo DateTime la fecha incluye también la hora. Establece
    # las fechas de inicio y fin al principio del día y al final del día,
    # respectivamente.
    #
    def datetimes_for_day
      self.date_start = date_start.to_datetime.beginning_of_day.to_s(:db)
      self.date_end = date_end.to_datetime.end_of_day.to_s(:db)
    end

    ##
    # Las fechas vienen en formato mm/yyyy. Establece las fechas de inicio y fin
    # al principio del mes y al final del mes, respectivamente.
    #
    def dates_for_month
      self.date_start = date_start.to_date.to_s
      self.date_end = date_end.to_date.end_of_month.to_s
    end

    ##
    # Si un campo es DateTime, tenemos que ir a la primera y a la última hora
    # del mes.
    #
    def datetimes_for_month
      self.date_start = date_start.to_datetime.to_s(:db)
      self.date_end = date_end.to_datetime.end_of_month.to_s(:db)
    end

    ##
    # Las fechas vienen en formato yyyy. Establece las fechas de inicio y fin
    # al principio del año y al final del año, respectivamente.
    #
    def dates_for_year
      self.date_start = Date.new(date_start.to_i).to_s
      self.date_end = Date.new(date_end.to_i).end_of_year.to_s
    end

    ##
    # Si el campo de DateTime, tenemos que ir a la primera y a la última hora
    # del año. Usamos UTC porque se crean nuevos objetos DateTime.
    #
    def datetimes_for_year
      self.date_start = Time.new(date_start.to_i).utc.to_s(:db)
      self.date_end = Time.new(date_end.to_i).utc.end_of_year.to_s(:db)
    end

    ##
    # Obtener la fecha de inicio desde los parámetros de Ransack.
    #
    def date_start
      params[:q][self.class.date_start_param]
    end

    ##
    # Obtener la fecha de fin desde los parámetros de Ransack.
    #
    def date_end
      params[:q][self.class.date_end_param]
    end

    ##
    # Establecer la fecha de inicio en los parámetros de Ransack.
    #
    def date_start=(date)
      params[:q][self.class.date_start_param] = date
    end

    ##
    # Establecer la fecha de fin en los parámetros de Ransack.
    #
    def date_end=(date)
      params[:q][self.class.date_end_param] = date
    end
  end

  class_methods do
    attr_reader :date_start_param, :date_end_param

    def date_param(date_param)
      @date_start_param = "#{date_param}_gteq"
      @date_end_param = "#{date_param}_lteq"
    end
  end
end
