# frozen_string_literal: true

json.array! @clients do |c|
  json.id c.id
  json.label client_label(c)
  json.city_id c.city_id
  json.plan_service_id c.plan_service_id
end
