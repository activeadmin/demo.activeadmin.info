ActiveAdmin.register User do
  menu priority: 4
  config.batch_actions = true

  filter :username
  filter :email
  filter :created_at

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :created_at
    actions
  end

  sidebar "Customer Details", only: :show do
    attributes_table_for user, :username, :email, :created_at
  end

  sidebar "Order History", only: :show do
    attributes_table_for user do
      row("Total Orders") { user.orders.complete.count }
      row("Total Value") do
        number_to_currency user.orders.complete.sum(:total_price)
      end
    end
  end

  sidebar "Active Admin Demo" do
    render("/admin/sidebar_links", model: "users")
  end
end
