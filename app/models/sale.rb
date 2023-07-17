class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :content, optional: true
end
