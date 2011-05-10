ActiveAdmin::Dashboards.build do

  section "Recent Orders" do
    table_for Order.complete.limit(10) do
      column("Order", :sortable => :id){|order| link_to "##{order.id}", admin_order_path(order) }
      column("State"){|order| status_tag(order.state) }
      column("Date", :sortable => :checked_out_at){|order| pretty_format(order.checked_out_at) }
      column("Customer", :sortable => :user_id){|order| auto_link(order.user) }
      column("Total"){|order| number_to_currency order.total_price }
    end
  end

  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     content_tag :ul do
  #       Post.recent(5).collect do |post|
  #         content_tag(:li, link_to(post.title, admin_post_path(post)))
  #       end.join.html_safe
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendererd within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
  #   section "Recent Posts" do
  #     render 'recent_posts' # => this will render /app/views/admin/dashboard/_recent_posts.html.erb
  #   end
  
  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.

end
