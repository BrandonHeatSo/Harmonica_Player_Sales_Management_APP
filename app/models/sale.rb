class Sale < ApplicationRecord
  belongs_to :user
  belongs_to :content, optional: true

  validates :sales_date, presence: true
  validates :customer, presence: true, length: { maximum: 50 }
  validates :amount, presence: true
  validates :note, length: { maximum: 100 }
  validates :payment_method, presence: true

  # createアクション時とupdateアクション時のみ適用
  validates :content_id, presence: { message: 'の選択は必須です。選択肢が無ければ、案件内容を作成して下さい。' }, on: [:create, :update]

  scope :by_year, ->(year) {
    if ActiveRecord::Base.connection.adapter_name.downcase == 'postgresql'
      where("date_part('year', sales_date) = ?", year)
    else
      where("strftime('%Y', sales_date) = ?", year)
    end
  }
  
end
