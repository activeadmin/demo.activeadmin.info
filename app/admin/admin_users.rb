ActiveAdmin.register AdminUser do
  menu :parent => 'Administration'

  filter :email
  filter :created_at
  filter :last_sign_in_at

  index do
    id_column
    column :email
    column :last_sign_in_at
    default_actions
  end

  form do |f|
    f.inputs "User Details", :email
    f.inputs "Password", :password, :password_confirmation
    f.buttons
  end

  # Don't update password unless set by the user
  before_filter :only => :update do
    if params[:admin_user][:password] == "" && params[:admin_user][:password_confirmation] == ""
      params[:admin_user].delete(:password)
      params[:admin_user].delete(:password_confirmation)
    end
  end
end
