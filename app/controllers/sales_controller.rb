class SalesController < ApplicationController
  before_action :authenticate_user! # Deviseを使用してログイン済みのユーザーを要求
  before_action :set_sale, only: [:edit, :update, :destroy]

  def index
    # 現在の年の売上データを取得
    current_year = Time.now.year
    @sales = current_user.sales.where("strftime('%Y', sales_date) = ?", current_year.to_s).order(sales_date: :desc)
    # 年の選択肢を生成
    @available_years = available_years
    # フォームで年を選択した場合は、選択した年の売上データを表示
    if params[:date] && params[:date][:year]
      year = params[:date][:year].to_i
      @sales = current_user.sales.where("strftime('%Y', sales_date) = ?", year.to_s).order(sales_date: :desc)
    end
    respond_to do |format| # CSV出力用アクション
      format.html
      format.csv do
        csv_data = SalesCSVExporter.export(@sales, self)
        send_data csv_data, filename: "#{current_user.name}の#{year}分の売上一覧.csv"
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

  def available_years
    years_with_sales = current_user.sales.distinct.pluck("strftime('%Y', sales_date)").map(&:to_i)
    current_year = Time.now.year
    if years_with_sales.present?
      all_years = years_with_sales
    else
      all_years = [current_year]
    end
    all_years.sort.reverse
  end
end
