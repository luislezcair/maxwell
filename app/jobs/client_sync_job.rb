# frozen_string_literal: true

# Job que se encarga de sincronizar los clientes desde Contabilium y UCRM a
# Maxwell.
#
# 1. Se obtienen todos los clientes desde Contabilium
# 2. Se obtienen todos los clientes desde UCRM.
# 3. Se matchean ambas listas usando el código de cliente (campo `código` en
#    Contabilium y `userIdent` en UCRM).
# 4. Con esta nueva lista se buscan los clientes que todavía no existen en
#    Maxwell con el mísmo campo código y se los agrega.
#
class ClientSyncJob
  include Sidekiq::Worker

  EXCEPT_ATTRS = %w[id number created_at updated_at].freeze

  def perform
    # Convertimos todos los clientes de Contabilium y UCRM a una representación
    # común: clientes de Maxwell.
    clients_c = contabilium_clients.map(&:to_maxwell_model)
    clients_u = ucrm_clients.map(&:to_maxwell_model)

    clients = match_with(clients_c, clients_u)

    # Ahora clients es una lista de clientes con contabilium_id y ucrm_id
    # Si el cliente ya existe, actualizamos los atributos por si hubo cambios.
    # Si el cliente no se encuentra en el sistema, guardamos el cliente que
    # viene de Contabilium porque es uno nuevo.
    clients.each do |c|
      client = Client.find_by(number: c.number)

      if client
        client.update(c.attributes.except(*EXCEPT_ATTRS))
      elsif c.save
        logger.info("Saving client with ID: #{c.id}")
      end
    end
  end

  protected

  # Tomamos los datos de Contabilium y buscamos el cliente correspondiente en
  # UCRM usando el código de cliente. Si hay clientes con el mismo código se
  # usa el primero y el otro se descarta.
  # Establece el campo ucrm_id y organization_id que son atributos propios de
  # UCRM. Devuelve un arreglo con los clientes que coincidieron.
  #
  def match_with(clients_c, clients_u)
    clients = []

    clients_c.each do |c|
      next if c.number.zero?

      uc = clients_u.select { |u| u.number == c.number }.first
      next unless uc

      c.ucrm_id = uc.ucrm_id
      c.organization_id = uc.organization_id
      clients << c
    end

    clients
  end

  # Consulta la primera página de la colección para obtener los primeros
  # resultados y la información sobre el total de elementos y la cantidad por
  # cada página. Con esto calcula el total de páginas y luego consulta las
  # páginas restantes.
  #
  def contabilium_clients
    logger.info('Fetching first page of results...')
    page = 1
    collection = Contab::Client.collection(page)

    total = collection.metadata[:total]
    per_page = collection.metadata[:count]
    total_pages = total.fdiv(per_page).ceil

    logger.info("Got #{per_page} clients of #{total} in total. "\
                "Total pages: #{total_pages}.")

    while page < total_pages
      page += 1
      logger.info("Fetching page #{page} of results...")
      next_collection = Contab::Client.collection(page)

      collection.concat(next_collection)
    end

    logger.info("Got #{collection.size} clients in total")
    collection
  end

  def ucrm_clients
    logger.info('Fetching all UCRM clients...')
    clients = UCRM::Client.all
    logger.info("Got #{clients.size}")
    clients
  end
end
