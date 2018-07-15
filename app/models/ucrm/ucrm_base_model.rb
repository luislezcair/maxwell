# frozen_string_literal: true

# Clase base para los modelos que se sincronizan con UCRM.
#
class UCRM::UCRMBaseModel
  include Her::Model
  use_api UCRM_API

  # Estos atributos hay que inicializarlos con los valores adecuados en cada
  # subclase. @klass es la clase del modelo local y @ucrm_local_field_id es el
  # campo que guarda el ID del modelo de UCRM.
  attr_reader :klass, :ucrm_local_id_field, :api_name

  def initialize(args = {})
    super(args)
    @api_name = 'UCRM'
  end

  # Método que debe devolver un modelo del sistema que se corresponda con el de
  # UCRM, rellenando los valores de atributos.
  #
  def to_maxwell_model
    @klass.new(maxwell_model_attributes.merge(find_by_attributes))
  end

  def maxwell_model
    @klass.find_by(find_by_attributes)
  end

  protected

  # Este método debe ser implementado en cada subclase. Debe devolver un Hash
  # con los atributos del modelo local mapeados con los valores del modelo UCRM.
  #
  def maxwell_model_attributes
    raise NotImplementedError
  end

  private

  # Devuelve un Hash con los atributos que se utilizan para verificar si ya
  # existe un objeto local para el ID que viene de UCRM.
  def find_by_attributes
    Hash[@ucrm_local_id_field, id]
  end
end