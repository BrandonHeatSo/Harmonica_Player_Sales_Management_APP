class CreateSales < ActiveRecord::Migration[5.1]
  def change
    create_table :sales do |t|
      t.datetime :sales_date
      t.string :customer
      t.decimal :amount, precision: 14, scale: 2
      t.string :note
      t.string :payment_method
      t.references :user, foreign_key: true
      t.references :content, foreign_key: true

      t.timestamps
    end
  end
end
