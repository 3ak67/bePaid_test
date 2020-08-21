class Post < ActiveRecord::Base
  belongs_to :user, required: true
  has_many :rates, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :content, presence: true
  validates :author_ip, presence: true
end