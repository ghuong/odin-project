class User < ApplicationRecord
  has_many :posts
  has_many :comments
  validates :username, presence: true
end
