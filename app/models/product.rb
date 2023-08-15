class Product < ActiveRecord::Base
  has_one_attached :image

  # Named Scopes
  scope :available, lambda{ where("available_on < ?", Date.today) }
  scope :drafts, lambda{ where("available_on > ?", Date.today) }

  # Validations
  validates_presence_of :title
  validates_presence_of :price
  validates_presence_of :image_file_name

  def self.ransackable_attributes(auth_object = nil)
    [
      "author", "available_on", "created_at", "description", "featured", "id", "image_file_name", "price", "title", "updated_at",
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    [
      "image_attachment"
    ]
  end
end

class ActiveStorage::Attachment < ActiveStorage::Record
  def self.ransackable_attributes(auth_object = nil)
    [
      "id", "blob_id"
    ]
  end
end
