# frozen_string_literal: true

json.array! @clients do |c|
  json.id c.id
  json.label client_label(c)
end
