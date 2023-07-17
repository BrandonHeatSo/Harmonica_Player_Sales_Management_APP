class Content < ApplicationRecord
  belongs_to :user
  has_many :sales, dependent: :nullify

  validates :name, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 255 }
end
