# frozen_string_literal: true

# Contabilium, siguiendo el manual de malas prácticas REST y la biblia de como
# arruinar la vida al prójimo, devuelve los datos de una colección como un
# objeto con el siguiente formato:
# {
#   Items: [{cliente 1}, {cliente 2}, ... ], # máximo 50 ìtems por página.
#   TotalPage: nn,
#   TotalItems: kk
# }
#
# Tenemos que devolver el arreglo de ítems directamente e informar el total.
# Pueden darse cinco casos:
#  1. La respuesta es una colección (descripto arriba).
#  2. La respuesta es un único objeto JSON normal.
#  3. La respuesta es un número entero: es el ID de un objeto recién creado por
#  un POST.
#  4. La respuesta es un string: es un mensaje de error.
#  5. Respuesta vacía: la respuesta a un PUT está vacía pero con status 200.
#
class ContabResponseParser < Faraday::Response::Middleware
  def on_complete(env)
    json = {}
    errors = []

    # Si hubo un error la respuesta es un string con el mensaje de error y
    # MultiJson genera un error al leer.
    begin
      json = MultiJson.load(env[:body], symbolize_keys: true)
    rescue MultiJson::LoadError
      errors = [env[:body]] if env[:status] >= 500
    end

    metadata = {}
    data = json

    # La respuesta a un POST es un id (un integer), si el objeto se creó
    # correctamente. MultiJson.load no genera un error cuando es un entero, por
    # lo tanto hay que tratarlo aparte.
    if json.is_a?(Integer)
      data = { response_id: json }
    elsif json.respond_to?(:include?) &&
          json.include?(:Items) &&
          json.include?(:TotalPage) &&
          json.include?(:TotalItems)
      # Tenemos que comprobar que estén estos tres elementos para saber que es
      # una colección, porque un Comprobante también tiene un atributo `Items`.
      data = json[:Items]
      metadata = { total: json[:TotalItems], count: json[:TotalPage] }
    end

    # Devolvemos el body en el formato que espera Her.
    env[:body] = {
      data: data,
      errors: errors,
      metadata: metadata
    }
  end
end
