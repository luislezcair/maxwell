# frozen_string_literal: true

json.array!(
  Account.arrange_serializable(order: Account::ORDER) do |node, children|
    {
      id: "acc_#{node.id}",
      text: node.to_label,
      children: children,
      icon: node.imputable ? 'fa fa-file-text' : 'fa fa-book'
    }
  end
)
