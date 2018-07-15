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
#
# TODO: esto pordría mejorarse incorporando comportamiento para el manejo de
# errores de https://github.com/remiprev/her/blob/master/lib/her/middleware/parse_json.rb
#
class ContabResponseParser < Faraday::Response::Middleware
  def on_complete(env)
    json = MultiJson.load(env[:body], symbolize_keys: true)

    data = json
    metadata = {}

    # Tenemos que comprobar que estén estos tres elementos para saber que es
    # una colección, porque un Comprobante también tiene un atributo `Items`.
    if json.include?(:Items) &&
       json.include?(:TotalPage) &&
       json.include?(:TotalItems)
      data = json[:Items]
      metadata = { total: json[:TotalItems], count: json[:TotalPage] }
    end

    # Devolvemos el body en el formato que espera Her.
    env[:body] = {
      data: data,
      errors: {},
      metadata: metadata
    }
  end
end
