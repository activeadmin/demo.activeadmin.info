ActiveAdmin::Dashboards.build do

  section "Recent Orders", :priority => 1 do
    table_for Order.complete.order('id desc').limit(10) do
      column("State")   {|order| status_tag(order.state)                                    }
      column("Customer"){|order| link_to(order.user.email, admin_user_path(order.user)) }
      column("Total")   {|order| number_to_currency order.total_price                       }
    end
  end

  section "Recent Customers", :priority => 2 do
    table_for User.order('id desc').limit(10).each do |user|
      column(:email)    {|user| link_to(user.email, admin_user_path(user)) }
    end
  end

  section "ActiveAdmin Demo", :priority => 3 do
    div do
      render('/admin/sidebar_links', :model => 'dashboards')
    end

    div do
      br
      text_node %{<iframe src="https://rpm.newrelic.com/public/charts/6VooNO2hKWB" width="500" height="300" scrolling="no" frameborder="no"></iframe>}.html_safe
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

