class SalesController < ApplicationController
  before_action :authenticate_user! # Deviseを使用してログイン済みのユーザーを要求
  before_action :set_sale, only: [:edit, :update, :destroy]

  # def index


    # ～パターン➀～

    # 現在の年の売上データを取得
    # current_year = Time.now.year
    # @sales = current_user.sales.where("strftime('%Y', sales_date) = ?", current_year.to_s).order(sales_date: :desc)
    # 年の選択肢を生成
    # @available_years = available_years
    # 年に基づいて月の選択肢を取得し、@months_with_salesに設定
    # @available_months = available_months
    # フォームで年と月を選択した場合は、選択した年と月の売上データを表示
    # if params[:date] && params[:date][:year] && params[:date][:month]
      # year = params[:date][:year].to_i
      # month = params[:date][:month].to_i
      # @sales = current_user.sales.where("strftime('%Y', sales_date) = ? AND strftime('%m', sales_date) = ?", year.to_s, '%02d' % month).order(sales_date: :desc)
    # end
    # 年選択のみ選択された場合は、選択中の年の全ての月の売上データを表示
    # if params[:date] && params[:date][:year].present? && params[:date][:month].blank?
      # year = params[:date][:year].to_i
      # @sales = current_user.sales.where("strftime('%Y', sales_date) = ?", year.to_s).order(sales_date: :desc)
    # end


    # ～パターン➁～

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


    # ～パターン➂～

    # 年と月のパラメータを取得
    # selected_year = params.dig(:date, :year)&.to_i
    # selected_month = params.dig(:date, :month)&.to_i

    # ユーザーの全売上データを取得
    # @sales = current_user.sales.order(sales_date: :desc)

    # 年が選択されている場合はフィルタリング
    # if selected_year.positive?
      # @sales = @sales.select { |sale| sale.sales_date.year == selected_year }

      # 月が選択されている場合はさらにフィルタリング
      # if selected_month.positive?
        # @sales = @sales.select { |sale| sale.sales_date.month == selected_month }
      # end
    # end


    # ～パターン➃～

    # 売上データが存在する年を取得
    # years_with_sales = current_user.sales.map { |sale| sale.sales_date.year }.uniq

    # 全ての年を取得して重複を除外し、降順に並び替える
    # @available_years = years_with_sales + [Time.now.year]
    # @available_years.uniq!
    # @available_years.sort!.reverse!

    # 選択された年に対応する売上データの月を取得
    # selected_year = params.dig(:date, :year)&.to_i

    # if selected_year && selected_year.positive?
      # months_with_sales = current_user.sales.select { |sale| sale.sales_date.year == selected_year }
                                            # .map { |sale| sale.sales_date.month }.uniq

      # 選択された年の月を降順に並び替える
      # @available_months = months_with_sales.sort.reverse
    # else
      # @available_months = []
    # end

    # ユーザーの全売上データを取得
    # @sales = current_user.sales.order(sales_date: :desc)

    # 年が選択されている場合はフィルタリング
    # if selected_year && selected_year.positive?
      # @sales = @sales.select { |sale| sale.sales_date.year == selected_year }

      # 月が選択されている場合はさらにフィルタリング
      # selected_month = params.dig(:date, :month)&.to_i
      # if selected_month && selected_month.positive?
        # @sales = @sales.select { |sale| sale.sales_date.month == selected_month }
      # end
    # end


    # パターン➄（昇順降順切替え機能付き）～

    # 売上データが存在する年を取得
    # years_with_sales = current_user.sales.map { |sale| sale.sales_date.year }.uniq

    # 全ての年を取得して重複を除外し、降順に並び替える
    # @available_years = years_with_sales + [Time.now.year]
    # @available_years.uniq!
    # @available_years.sort!.reverse!

    # 選択された年に対応する売上データの月を取得
    # selected_year = params.dig(:date, :year)&.to_i
    # selected_month = params.dig(:date, :month)&.to_i

    # 選択された並び順を取得
    # selected_order = params[:order]

    # ユーザーの全売上データを取得
    # @sales = current_user.sales.order(sales_date: :desc)

    # 年が選択されている場合はフィルタリング
    # if selected_year && selected_year.positive?
      # @sales = @sales.select { |sale| sale.sales_date.year == selected_year }

      # 月が選択されている場合はさらにフィルタリング
      # if selected_month && selected_month.positive?
        # @sales = @sales.select { |sale| sale.sales_date.month == selected_month }
      # end

      # 選択された年の月を取得して降順に並び替える
      # months_with_sales = @sales.map { |sale| sale.sales_date.month }.uniq
      # @available_months = months_with_sales.sort.reverse

    # else
      # 年が選択されていない場合、現在の年の売上データのみを表示
      # current_year = Time.now.year
      # @sales = @sales.select { |sale| sale.sales_date.year == current_year }

      # 現在の年の月を取得して降順に並び替える
      # months_with_sales = @sales.map { |sale| sale.sales_date.month }.uniq
      # @available_months = months_with_sales.sort.reverse

    # end


    # ～以前の昇順降順ボタン用の記述パターン➀～

    # パラメーターでorderが指定されている場合は、昇順・降順を切り替える➀
    # if params[:order] && %w[asc desc].include?(params[:order])
      # @sales = @sales.reorder(sales_date: params[:order].to_sym)
    # end

    # ～以前の昇順降順ボタン用の記述パターン➁～

    # パラメーターでorderが指定されている場合は、昇順・降順を切り替える➁
    # if params[:order].in?(['asc', 'desc'])
      # @sales = @sales.reorder(sales_date: params[:order].to_sym)
    # end

    # ～以前の昇順降順ボタン用の記述パターン➂～

    # 選択された並び順による並び替え
    # if selected_order.in?(['asc', 'desc'])
      # @sales = @sales.reorder(sales_date: selected_order.to_sym)
    # end

    # ～以前の昇順降順ボタン用の記述パターン➃～

    # 選択された並び順による並び替え
    # if selected_order.in?(['asc', 'desc'])
      # @sales = @sales.sort_by { |sale| sale.sales_date }.send(selected_order)
    # end


    # ～合計金額＆CSV出力パターン➀～

    # 表示中の売上金額合計を計算してインスタンス変数に代入
    # @total_amount = @sales.sum(:amount)

    # CSV出力時は常に昇順（古い順）で出力するため、@salesを昇順に並び替える
    # if request.format.csv?
      # year = params[:date][:year].to_i
      # @sales = current_user.sales.where("strftime('%Y', sales_date) = ?", year.to_s).order(sales_date: :asc)
    # end

    # CSV出力用アクション
    # respond_to do |format|
      # format.html
      # format.csv do
        # csv_data = SalesCSVExporter.export(@sales)
        # send_data csv_data, filename: "#{current_user.name} #{year}年分 売上台帳.csv"
      # end
    # end
  # end

  def index

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
  
  # def available_years
    # current_year = Time.now.year
    # if Rails.env.production? # 本番環境 (Heroku) では PostgreSQL を使用する
      # @years = Sale.where(user_id: current_user.id)
                   # .group("EXTRACT(YEAR FROM sales_date)")
                   # .pluck("EXTRACT(YEAR FROM sales_date)")
                   # .map { |year| year.to_i }
    # else # 開発環境 (SQLite3) では SQLite3 の strftime を使用する
      # @years = Sale.where(user_id: current_user.id)
                   # .group("strftime('%Y', sales_date)")
                   # .pluck("strftime('%Y', sales_date)")
                   # .map(&:to_i)
    # end
    # @years = [current_year] if @years.blank?
    # @years.sort.reverse
  # end

  # def available_years
    # current_year = Time.now.year
    # if Rails.env.production? # 本番環境 (Heroku) では PostgreSQL を使用する
      # @years = Sale.where(user_id: current_user.id)
                   # .group("date_part('year', sales_date)")
                   # .pluck("date_part('year', sales_date)")
                   # .map(&:to_i)
    # else # 開発環境 (SQLite3) では SQLite3 の strftime を使用する
      # @years = Sale.where(user_id: current_user.id)
                   # .group("strftime('%Y', sales_date)")
                   # .pluck("strftime('%Y', sales_date)")
                   # .map(&:to_i)
    # end
    # @years = [current_year] if @years.blank?
    # @years.sort.reverse
  # end
  
  # def available_years
    # current_year = Time.now.year
    # if Rails.env.production? # 本番環境 (Heroku) では PostgreSQL を使用する
      # @years = Sale.where(user_id: current_user.id)
                   # .group("EXTRACT(YEAR FROM sales_date)")
                   # .pluck("EXTRACT(YEAR FROM sales_date) AS year")
                   # .map(&:to_i)
    # else # 開発環境ではデータベースに応じてクエリを切り替える
      # adapter = ActiveRecord::Base.connection.adapter_name.downcase.to_sym
      # if adapter == :sqlite
        # @years = Sale.where(user_id: current_user.id)
                     # .group("strftime('%Y', sales_date)")
                     # .pluck("strftime('%Y', sales_date) AS year")
                     # .map(&:to_i)
      # elsif adapter == :postgresql
        # @years = Sale.where(user_id: current_user.id)
                     # .group("DATE_PART('YEAR', sales_date)")
                     # .pluck("DATE_PART('YEAR', sales_date) AS year")
                     # .map(&:to_i)
      # end
    # end
    # @years = [current_year] if @years.blank?
    # @years.sort.reverse
  # end

  # def available_months
    # if params.dig(:date, :year).present?
      # year = params[:date][:year].to_i
      # months_with_sales = current_user.sales.where("strftime('%Y', sales_date) = ?", year.to_s).distinct.pluck("strftime('%m', sales_date)").map(&:to_i)
      # all_months =  months_with_sales
    # else
      # all_months = (1..12).to_a
    # end
    # all_months.sort.reverse
  # end
  
  # def available_years_without_db_query
    # current_year = Time.now.year
    # @years = [current_year]
    # @years.sort.reverse
  # end

end
