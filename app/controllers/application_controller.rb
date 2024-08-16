class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def route_not_found
    render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
  end
end
