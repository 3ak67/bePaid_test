class User < ActiveRecord::Base
  validates :login, uniqueness: true, presence: true
  has_many :posts
end