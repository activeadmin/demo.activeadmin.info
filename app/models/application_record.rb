# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.ransackable_attributes(auth_object=nil)
    authorizable_ransackable_attributes
  end

  def self.ransackable_associations(auth_object=nil)
    authorizable_ransackable_associations
  end
end
