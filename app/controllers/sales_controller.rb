class SalesController < ApplicationController
  before_action :authenticate_user! # Deviseを使用してログイン済みのユーザーを要求
  before_action :set_sale, only: [:edit, :update, :destroy]

  def index
    # 現在の年の売上データを取得
    current_year = Time.now.year
    @sales = current_user.sales.where("strftime('%Y', sales_date) = ?", current_year.to_s).order(sales_date: :desc)
    # 年の選択肢を生成
    @available_years = available_years
    # 年に基づいて月の選択肢を取得し、@months_with_salesに設定
    @available_months = available_months
    # フォームで年と月を選択した場合は、選択した年と月の売上データを表示
    if params[:date] && params[:date][:year] && params[:date][:month]
      year = params[:date][:year].to_i
      month = params[:date][:month].to_i
      @sales = current_user.sales.where("strftime('%Y', sales_date) = ? AND strftime('%m', sales_date) = ?", year.to_s, '%02d' % month).order(sales_date: :desc)
    end
    # 年選択のみ選択された場合は、選択中の年の全ての月の売上データを表示
    if params[:date] && params[:date][:year].present? && params[:date][:month].blank?
      year = params[:date][:year].to_i
      @sales = current_user.sales.where("strftime('%Y', sales_date) = ?", year.to_s).order(sales_date: :desc)
    end
    # パラメーターでorderが指定されている場合は、昇順・降順を切り替える
    if params[:order] && %w[asc desc].include?(params[:order])
      @sales = @sales.reorder(sales_date: params[:order].to_sym)
    end

    # @available_years = available_years
    # @available_months = available_months

    # selected_year = params.dig(:date, :year).to_i
    # selected_month = params.dig(:date, :month).to_i

    # if selected_year != 0 && selected_month != 0
      # @sales = current_user.sales.where("strftime('%Y', sales_date) = ? AND strftime('%m', sales_date) = ?", selected_year.to_s, '%02d' % selected_month).order(sales_date: :desc)
    # elsif selected_year != 0
      # @sales = current_user.sales.where("strftime('%Y', sales_date) = ?", selected_year.to_s).order(sales_date: :desc)
    # else
      # current_year = Time.now.year
      # @sales = current_user.sales.where("strftime('%Y', sales_date) = ?", current_year.to_s).order(sales_date: :desc)
    # end

    # if params[:order].in?(['asc', 'desc'])
      # @sales = @sales.reorder(sales_date: params[:order].to_sym)
    # end

    # 表示中の売上金額合計を計算してインスタンス変数に代入
    @total_amount = @sales.sum(:amount)
    # CSV出力時は常に昇順（古い順）で出力するため、@salesを昇順に並び替える
    if request.format.csv?
      year = params[:date][:year].to_i
      @sales = current_user.sales.where("strftime('%Y', sales_date) = ?", year.to_s).order(sales_date: :asc)
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

  # def available_years
    # years_with_sales = current_user.sales.distinct.pluck("strftime('%Y', sales_date)").map(&:to_i)
    # current_year = Time.now.year
    # if years_with_sales.present?
      # all_years = years_with_sales
    # else
      # all_years = [current_year]
    # end
    # all_years.sort.reverse
  # end

  # def available_months
    # if params.dig(:date, :year).present?
      # year = params[:date][:year].to_i
      # months_with_sales = current_user.sales.where("strftime('%Y', sales_date) = ?", year.to_s).distinct.pluck("strftime('%m', sales_date)").map(&:to_i)
      # all_months = (1..12).to_a.to_a.sort.reverse
      # all_months & months_with_sales
    # else
      # (1..12).to_a.sort.reverse
    # end
  # end

  # def available_years
    # current_year = Time.now.year
    # if ActiveRecord::Base.connection.adapter_name.downcase == 'postgresql'
      # @years = Sale.where(user_id: current_user.id).pluck("DISTINCT date_part('year', sales_date)::integer")
      # if @years.present?
        # all_years = @years
      # else
        # all_years = [current_year]
      # end
    # else
      # @years = Sale.where(user_id: current_user.id).pluck("DISTINCT strftime('%Y', sales_date) AS year").map { |year| year['year'].to_i }
      # years_with_sales = current_user.sales.distinct.pluck("strftime('%Y', sales_date)").map(&:to_i)
      # if years_with_sales.present?
        # all_years = years_with_sales
      # else
        # all_years = [current_year]
      # end
    # end
    # all_years.sort.reverse    
  # end

  def available_years
    current_year = Time.now.year
    # @years = Sale.where(user_id: current_user.id).distinct.pluck(:sales_date).map { |date| date.year }
    # @years = Sale.where(user_id: current_user.id).distinct.pluck("date_part('year', sales_date)").map(&:to_i)
    # @years = Sale.where(user_id: current_user.id).group("strftime('%Y', sales_date)").pluck("strftime('%Y', sales_date)").map(&:to_i)
    sales = Sale.where(user_id: current_user.id)
    @years = sales.pluck(:sales_date).map { |date| date.year }.uniq
    @years = [current_year] if @years.blank?
    @years.sort.reverse
  end

  def available_months
    if params.dig(:date, :year).present?
      year = params[:date][:year].to_i
      months_with_sales = current_user.sales.where("strftime('%Y', sales_date) = ?", year.to_s).distinct.pluck("strftime('%m', sales_date)").map(&:to_i)
      all_months =  months_with_sales
    else
      all_months = (1..12).to_a
    end
    all_months.sort.reverse
  end
  
end
