class Rate < ActiveRecord::Base
  belongs_to :post, required: true
  validates :value, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end