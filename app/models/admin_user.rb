# frozen_string_literal: true

class AdminUser < ApplicationRecord
  DEFAULT_EMAIL = "admin@example.com"
  DEFAULT_PASSWORD = "password"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
