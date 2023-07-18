class SalesController < ApplicationController
  before_action :authenticate_user! # Deviseを使用してログイン済みのユーザーを要求
  before_action :set_sale, only: [:edit, :update, :destroy]

  def index
    if params[:year]
      year = params[:year].to_i
      @sales = current_user.sales.where("EXTRACT(YEAR FROM sales_date) = ?", year).order(sales_date: :desc)
    else
      @sales = current_user.sales.order(sales_date: :desc) # ログインユーザーの売上データを降順で取得
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
