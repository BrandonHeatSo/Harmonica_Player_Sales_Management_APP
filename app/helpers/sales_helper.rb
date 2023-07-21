module SalesHelper
  def content_not_selected_text(sale)
    content_tag(:span, '削除済の案件内容です。他の選択肢へと編集して下さい。', style: 'color: red;')
  end
end
