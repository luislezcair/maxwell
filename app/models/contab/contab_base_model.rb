# frozen_string_literal: true

require 'contab_api'

# Clase base para los modelos que se sincronizan con Contabilium
#
class Contab::ContabBaseModel
  include Her::Model

  # La API se tiene que configurar con cada consulta porque hay que leer el
  # token de la base de datos o pedir uno nuevo si no hay o está expirado.
  use_api(proc { ContabAPI.new.api })

  # Estos atributos hay que inicializarlos con los valores adecuados en cada
  # subclase. @klass es la clase del modelo local y @contab_local_field_id es el
  # campo que guarda el ID del modelo de Contabilium.
  attr_reader :klass, :contab_local_id_field, :api_name

  def initialize(args = {})
    super(args)
    @api_name = 'Contabilium'
  end

  # Método que debe devolver un modelo del sistema que se corresponda con el de
  # Contabilium, rellenando los valores de atributos.
  #
  def to_maxwell_model
    @klass.new(maxwell_model_attributes.merge(find_by_attributes))
  end

  def maxwell_model
    @klass.find_by(find_by_attributes)
  end

  protected

  # Este método debe ser implementado en cada subclase. Debe devolver un Hash
  # con los atributos del modelo local mapeados con los valores del modelo
  # Contabilium.
  #
  def maxwell_model_attributes
    raise NotImplementedError
  end

  private

  # Devuelve un Hash con los atributos que se utilizan para verificar si ya
  # existe un objeto local para el ID que viene de Contabilium.
  # Contabilium mezcla Id con ID. Por qué? No hay por qué.
  #
  def find_by_attributes
    id = if respond_to?(:ID)
           self.ID
         else
           self.Id
         end
    Hash[@contab_local_id_field, id]
  end
end
