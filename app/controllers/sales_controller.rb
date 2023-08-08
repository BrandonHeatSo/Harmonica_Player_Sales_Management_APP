class SalesController < ApplicationController
  before_action :authenticate_user! # Deviseを使用してログイン済みのユーザーを要求
  before_action :set_sale, only: [:edit, :update, :destroy]

  def index
    # 現在の年を取得
    @current_year = Time.now.year
    
    # 売上データが存在する年を取得
    years_with_sales = current_user.sales.map { |sale| sale.sales_date.year }.uniq

    # 全ての年を取得して重複を除外し、降順に並び替える
    @available_years = years_with_sales + [Time.now.year]
    @available_years.uniq!
    @available_years.sort!.reverse!

    # 選択された年に対応する売上データの月を取得
    selected_year = params.dig(:date, :year)&.to_i
    selected_month = params.dig(:date, :month)&.to_i

    # 選択された並び順を取得
    selected_order = params[:order]

    # ユーザーの全売上データを取得
    @sales = current_user.sales.order(sales_date: :desc)

    # 年が選択されている場合はフィルタリング
    if selected_year && selected_year.positive?
      @sales = @sales.select { |sale| sale.sales_date.year == selected_year }
    else
      # 年が選択されていない場合、現在の年の売上データのみを表示
      current_year = Time.now.year
      @sales = @sales.select { |sale| sale.sales_date.year == current_year }
    end

    # 月の情報を取得して降順に並び替える
    months_with_sales = @sales.map { |sale| sale.sales_date.month }.uniq
    @available_months = months_with_sales.sort.reverse

    # 月が選択されている場合はフィルタリング
    if selected_month && selected_month.positive?
      @sales = @sales.select { |sale| sale.sales_date.month == selected_month }
    end

    # 選択された並び順による並び替え
    if selected_order.in?(['asc', 'desc'])
      @sales = @sales.sort_by { |sale| sale.sales_date }
      @sales.reverse! if selected_order == 'desc'
    end

    # 表示中の売上金額合計を計算してインスタンス変数に代入
    @total_amount = @sales.sum { |sale| sale.amount.to_i }

    # CSV出力時は常に昇順（古い順）で出力するため、@salesを昇順に並び替える
    if request.format.csv?
      year = params.dig(:date, :year).to_i
      @sales = current_user.sales.where(sales_date: Date.new(year, 1, 1)..Date.new(year, 12, 31))
                                 .order(sales_date: :asc)
    end

    # CSV出力用アクション
    respond_to do |format|
      format.html
      format.csv do
        csv_data = SalesCSVExporter.export(@sales)
        send_data csv_data, filename: "#{current_user.name} #{year}年分 売上台帳.csv"
      end
    end
  end
  
  def new
    @sale = current_user.sales.build # ログインユーザーに紐付いた新しい売上データを作成
  end

  def create
    @sale = current_user.sales.build(sale_params) # ログインユーザーに紐付いた売上データを作成
    if @sale.save
      redirect_to user_content_sales_path(current_user), notice: '売上データの新規作成に成功しました。'
    else
      render :new
    end
  end

  def edit
    # @saleはbefore_actionでセット済み
  end

  def update
    if @sale.update(sale_params)
      redirect_to user_content_sales_path(current_user), notice: '売上データが正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @sale.destroy
    redirect_to user_content_sales_path(current_user), notice: '売上データが正常に削除されました。'
  end

  private

  def set_sale
    @sale = current_user.sales.find(params[:id]) # ログインユーザーの売上データを検索
  end

  def sale_params
    params.require(:sale).permit(:sales_date, :customer, :amount, :note, :payment_method, :content_id)
  end
end
