# frozen_string_literal: true

# 配達先コントローラー
# 配達ルートに紐づく配達先のCRUD操作を提供
class DeliveryPointsController < ApplicationController
  before_action :set_delivery_route
  before_action :set_delivery_point, only: [:edit, :update, :destroy, :update_status]

  # 新規作成フォーム
  # GET /delivery_routes/:delivery_route_id/delivery_points/new
  def new
    @delivery_point = @delivery_route.delivery_points.build
  end

  # 編集フォーム
  # GET /delivery_routes/:delivery_route_id/delivery_points/:id/edit
  def edit
  end

  # 作成処理
  # POST /delivery_routes/:delivery_route_id/delivery_points
  def create
    @delivery_point = @delivery_route.delivery_points.build(delivery_point_params)

    if @delivery_point.save
      redirect_to @delivery_route, notice: "配達先を追加しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 更新処理
  # PATCH/PUT /delivery_routes/:delivery_route_id/delivery_points/:id
  def update
    if @delivery_point.update(delivery_point_params)
      redirect_to @delivery_route, notice: "配達先を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除処理
  # DELETE /delivery_routes/:delivery_route_id/delivery_points/:id
  def destroy
    @delivery_point.destroy!
    redirect_to @delivery_route, notice: "配達先を削除しました。", status: :see_other
  end

  # ステータス更新（配達済み/未配達/不在）
  # PATCH /delivery_routes/:delivery_route_id/delivery_points/:id/status
  def update_status
    if @delivery_point.update(status: params[:status])
      respond_to do |format|
        format.html { redirect_to @delivery_route, notice: "ステータスを更新しました。" }
        format.turbo_stream
      end
    else
      redirect_to @delivery_route, alert: "ステータスの更新に失敗しました。"
    end
  end

  private

  # 親の配達ルートを取得
  def set_delivery_route
    @delivery_route = current_user.delivery_routes.find(params[:delivery_route_id])
  end

  # 対象の配達先を取得
  def set_delivery_point
    @delivery_point = @delivery_route.delivery_points.find(params[:id])
  end

  # 許可するパラメータ
  def delivery_point_params
    params.require(:delivery_point).permit(:name, :address, :memo, :position, :status)
  end
end
