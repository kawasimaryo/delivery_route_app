# frozen_string_literal: true

# 配達ルートコントローラー
# 配達ルートのCRUD操作を提供
class DeliveryRoutesController < ApplicationController
  before_action :set_delivery_route, only: [:show, :edit, :update, :destroy, :optimize]

  # 配達ルート一覧
  # GET /delivery_routes
  def index
    @delivery_routes = current_user.delivery_routes.recent
  end

  # 配達ルート詳細
  # GET /delivery_routes/:id
  def show
    @delivery_points = @delivery_route.delivery_points.ordered
  end

  # 新規作成フォーム
  # GET /delivery_routes/new
  def new
    @delivery_route = current_user.delivery_routes.build(date: Date.current)
  end

  # 編集フォーム
  # GET /delivery_routes/:id/edit
  def edit
  end

  # 作成処理
  # POST /delivery_routes
  def create
    @delivery_route = current_user.delivery_routes.build(delivery_route_params)

    if @delivery_route.save
      redirect_to @delivery_route, notice: "配達ルートを作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 更新処理
  # PATCH/PUT /delivery_routes/:id
  def update
    if @delivery_route.update(delivery_route_params)
      redirect_to @delivery_route, notice: "配達ルートを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除処理
  # DELETE /delivery_routes/:id
  def destroy
    @delivery_route.destroy!
    redirect_to delivery_routes_path, notice: "配達ルートを削除しました。", status: :see_other
  end

  # ルート最適化
  # POST /delivery_routes/:id/optimize
  def optimize
    result = RouteOptimizationService.new(@delivery_route).call

    if result[:success]
      @delivery_points = @delivery_route.delivery_points.ordered.reload
      @polyline = result[:polyline]

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @delivery_route, notice: "ルートを最適化しました。" }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          flash.now[:alert] = result[:error]
          render turbo_stream: turbo_stream.replace(
            "flash_messages",
            partial: "shared/flash"
          )
        end
        format.html { redirect_to @delivery_route, alert: result[:error] }
      end
    end
  end

  private

  # 対象の配達ルートを取得
  # 他ユーザーのルートにはアクセス不可
  def set_delivery_route
    @delivery_route = current_user.delivery_routes.find(params[:id])
  end

  # 許可するパラメータ
  def delivery_route_params
    params.require(:delivery_route).permit(:name, :description, :date, :status)
  end
end
