# frozen_string_literal: true

json.array!(Account.arrange_serializable(order: :code) do |node, children|
  {
    id: "acc_#{node.id}",
    text: "#{node.code} - #{node.name}",
    children: children,
    icon: node.imputable ? 'fa fa-file-text' : 'fa fa-book'
  }
end)
