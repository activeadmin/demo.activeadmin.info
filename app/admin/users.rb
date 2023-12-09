ActiveAdmin.register User do
  menu priority: 4
  config.batch_actions = true

  config.add_sidebar_section "Customer Details", only: :show

  config.add_sidebar_section "Order History", only: :show

  config.add_sidebar_section "Active Admin Demo", {}

end
