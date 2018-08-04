# frozen_string_literal: true

# Helpers utilizados en las vistas de Technical Services.
#
module TechnicalServicesHelper
  COST_TYPE_FREE = 1
  COST_TYPE_NONFREE = 2

  # Mostrar solamente los técnicos que estén activos.
  #
  def sorted_active_technicians
    Technician.active.sorted
  end

  # Mostrar solamente los clientes que estén en Contabilium y UCRM ordenados.
  #
  def sorted_clients
    Client.synced.sorted
  end

  def sorted_cities
    City.sorted
  end

  def sorted_plan_services
    PlanService.sorted
  end

  def sorted_towers
    Tower.sorted
  end

  def sorted_transmitters
    Transmitter.sorted
  end

  def sorted_devices
    Device.sorted
  end

  def sorted_balancers
    Balancer.sorted
  end

  def sorted_support_types
    SupportType.sorted
  end

  def sorted_ground_wire_setup_types
    GroundWireSetupType.sorted
  end

  def sorted_surge_protector_setup_types
    SurgeProtectorSetupType.sorted
  end

  # Devuelve un arreglo con [nombre, id] de los tipos de costos (bonificado y
  # no bonificado) para mostrarlo en un combobox.
  #
  def total_cost_types
    [
      [t_view('.search_form.total_cost_types.free'), COST_TYPE_FREE],
      [t_view('.search_form.total_cost_types.nonfree'), COST_TYPE_NONFREE]
    ]
  end

  # Devuelve el valor que debe tener el combobox 'Costo' de acuerdo a los
  # parámetros de ransack.
  #
  def total_cost_type_value(q_param)
    if q_param.total_cost_eq.present?
      COST_TYPE_FREE
    elsif q_param.total_cost_gt.present?
      COST_TYPE_NONFREE
    end
  end
end
