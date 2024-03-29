require 'csv' # CSVを取扱う為の大元のメソッド設定

class SalesCSVExporter
  def self.export(sales)
    bom = "\uFEFF" # 文字化け防止用にBOMを定義。

    CSV.generate(headers: true) do |csv|
      csv << ['売上日', '取引先', '案件内容', '売上金額（税込）', '備考', '受取方法']

      sales.each do |sale|
        content_name = sale.content ? sale.content.name : '' # 案件内容の名前を取得する
        sales_date_with_weekday = "#{sale.sales_date.strftime('%-m/%-d')} (#{days_of_the_week[sale.sales_date.wday]})"
        csv << [
          sales_date_with_weekday,
          sale.customer,
          content_name,
          sale.amount,
          sale.note,
          sale.payment_method
        ]
      end
    end.prepend(bom) # 生成したCSVデータの先頭にBOMを挿入
  end

  def self.days_of_the_week
    %w(日 月 火 水 木 金 土)
  end
end
