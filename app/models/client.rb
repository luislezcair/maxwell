# frozen_string_literal: true

# Representa un cliente, que puede ser una persona o una empresa.
# El atributo `number` es el código interno que se utiliza para identificar a
# un cliente.
#
class Client < ApplicationRecord
  extend Enumerize

  belongs_to :country
  belongs_to :organization
  belongs_to :province

  belongs_to :city, optional: true
  belongs_to :plan_service, optional: true

  has_many :technical_services, dependent: :restrict_with_error

  enumerize :client_type, in: { person: 0, company: 1 },
                          default: :person,
                          predicates: true

  enumerize :document_type, in: { dni: 0, cuit: 1 },
                            default: :dni,
                            predicates: true

  enumerize :iva_condition, in: { consumidor_final: 0, responsable_inscripto: 1,
                                  exento: 2, monotributista: 3 },
                            default: :consumidor_final,
                            predicates: true

  validates :number, presence: true,
                     uniqueness: true,
                     numericality: { greater_than: 0 }

  validates :document_number, presence: true, uniqueness: true
  validates :address, :client_type, :document_type, presence: true

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP,
                              allow_blank: true }

  validates :ucrm_id, :contabilium_id, uniqueness: { allow_nil: true }

  validate :client_type_information
  validate :company_has_cuit
  validate :date_of_birth_not_in_future

  include ClientNameSearchable

  scope :synced, -> { where.not(contabilium_id: nil, ucrm_id: nil) }

  # Devuelve true si tenemos un ID de UCRM y uno de Contabilium. Esto no
  # garantiza que el cliente exista en ambos sistemas pero reduce la
  # probabilidad de error.
  #
  def synced?
    contabilium_id.present? && ucrm_id.present?
  end

  # Devuelve un Hash con los atributos que coinciden entre UCRM y Maxwell para
  # actualizar solamente estos sin afectar a los demás atributos.
  #
  def attributes_for_ucrm_update
    attributes.except(*UCRM::Client::UNMATCHED_ATTRS)
  end

  # Devuelve un Hash con los atributos que coinciden entre Contabilium y Maxwell
  # para actualizar solamente estos sin afectar a los demás atributos.
  #
  def attributes_for_contabilium_update
    attributes.except(*Contab::Client::UNMATCHED_ATTRS)
  end

  private

  # Validar que si un cliente es una persona física, tenga nombre y apellido.
  # Si es una organización, tenga razón social.
  #
  def client_type_information
    if person?
      errors.add(:lastname, :client_type_person) if lastname.blank?
      errors.add(:firstname, :client_type_person) if firstname.blank?
    elsif company_name.blank?
      errors.add(:company_name, :client_type_company)
    end
  end

  # Si el cliente es una organización, el tipo de documento tiene que ser CUIT.
  #
  def company_has_cuit
    return unless company? && !cuit?

    errors.add(:document_type, :client_type_company)
  end

  def date_of_birth_not_in_future
    return unless date_of_birth && date_of_birth > Date.current

    errors.add(:date_of_birth, :not_in_the_future)
  end
end
