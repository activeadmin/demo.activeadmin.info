ActiveAdmin.register User do

  filter :username
  filter :email
  filter :created_at

  index do
    id_column
    column :username
    column :email
    column :created_at
    default_actions
  end

  show :title => :username do
    panel "Order History" do
      table_for(user.orders) do
        column("Order", :sortable => :id) {|order| link_to "##{order.id}", admin_order_path(order) }
        column("State")                   {|order| status_tag(order.state) }
        column("Date", :sortable => :checked_out_at){|order| pretty_format(order.checked_out_at) }
        column("Total")                   {|order| number_to_currency order.total_price }
      end
    end

    panel "Address Book" do
      table_for(user.user_addresses) do
        column("Fullname") {|a| link_to "#{a.fullname}", admin_user_user_address_path(user.id, a.id) }
        column("Address") {|a|
          span "#{a.address_line1}"
          br "#{a.address_line2}"
        }
        column :city
        column :state
        column :country
        column :zipcode
        tr :class => "action_items" do
          td link_to("New Address", new_admin_user_user_address_path(user), :class => :button)
        end
      end
    end
    active_admin_comments
  end

  sidebar "Customer Details", :only => :show do
    attributes_table_for user, :username, :email, :created_at
  end

  sidebar "Order History", :only => :show do
    attributes_table_for user do
      row("Total Orders") { user.orders.complete.count }
      row("Total Value") { number_to_currency user.orders.complete.sum(:total_price) }
    end
  end

  sidebar "Active Admin Demo" do
    render('/admin/sidebar_links', :model => 'users')
  end
end

