class Client < ApplicationRecord
  extend Enumerize

  belongs_to :city

  has_many :technical_services, dependent: :restrict_with_error

  enumerize :iva_condition, in: { consumidor_final: 0, responsable_inscripto: 1,
                                  excento: 2, monotributista: 3 },
                            default: :consumidor_final,
                            predicates: true

  enumerize :client_type, in: { person: 0, company: 1 },
                          default: :person,
                          predicates: true

  enumerize :document_type, in: { dni: 0, cuit: 1 },
                            default: :dni,
                            predicates: true

  validates :number, presence: true, uniqueness: true
  validates :document_number, presence: true, uniqueness: true

  include FullNameSearchable
end
