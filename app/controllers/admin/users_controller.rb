class Admin::UsersController < ActiveAdmin::ResourceController

  protected

  def permitted_attr_names
    %w[username email password]
  end
end
