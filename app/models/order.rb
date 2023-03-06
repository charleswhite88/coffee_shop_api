class Order < ApplicationRecord
  has_many :order_items
  has_many :items, through: :order_items

  enum status: {
    in_processing: 0,
    ready: 1,
    completed: 2
  }

  validates :customer_name, presence: true, length: { maximum: 255 }
  validates :total_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :paid, presence: true, length: { maximum: 255 }
  validates :status, presence: true, inclusion: { in: statuses.keys }

end