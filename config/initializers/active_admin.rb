ActiveAdmin.setup do |config|

  # == Site Title
  #
  # Set the title that is displayed on the main layout
  # for each of the active admin pages.
  #
  config.site_title = "Active Admin Depot"


  # == Default Namespace
  #
  # Set the default namespace each administration resource
  # will be added to. 
  #
  # eg: 
  #   config.default_namespace = :hello_world
  #
  # This will create resources in the HelloWorld module and
  # will namespace routes to /hello_world/*
  #
  # To set no namespace by default, use:
  #   config.default_namespace = false
  config.default_namespace = :admin


  # == User Authentication
  #
  # Active Admin will automatically call an authentication 
  # method in a before filter of all controller actions to 
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the controller.
  config.authentication_method = false # Disabled for demo


  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # to return the currently logged in user.
  config.current_user_method = false # Disabled for demo
  

  # == Admin Notes
  # 
  # Admin notes allow you to add notes to any model
  #
  # Admin notes are enabled by default, but can be disabled
  # by uncommenting this line:
  #
  config.admin_notes = true


  # == Controller Filters
  #
  # You can add before, after and around filters to all of your
  # Active Admin resources from here. 
  #
  # config.before_filter :do_something_awesome


  # == Register Stylesheets & Javascripts
  #
  # We recomend using the built in Active Admin layout and loading
  # up your own stylesheets / javascripts to customize the look
  # and feel.
  #
  # To load a stylesheet:
  config.register_stylesheet 'admin.css'
  #
  # To load a javascript file:
  #   config.register_javascript 'my_javascript.js'

  # Set the action to call for the root path. You can set different
  # roots for each namespace.
  # Default:
  # config.root_to = 'dashboard#index'

  # == Batch Actions
  # Enable and disable Batch Actions
  config.batch_actions = false

  # == CSV options
  # Set the CSV builder separator (default is ",")
  # config.csv_column_separator = ','</pre>
end
