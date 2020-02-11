class Producer < ActiveRecord::Base
  has_many :items
  has_secure_password
  validates_uniqueness_of :name, :email
end