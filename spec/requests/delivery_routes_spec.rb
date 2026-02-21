# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DeliveryRoutes", type: :request do
  describe "GET /delivery_routes" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get delivery_routes_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      let(:user) { create(:user) }

      before { sign_in user }

      context "ルートが存在する場合" do
        it "自分のルート一覧が表示されること" do
          create(:delivery_route, user: user, name: "自分のルート")
          other_user = create(:user)
          create(:delivery_route, user: other_user, name: "他人のルート")

          get delivery_routes_path

          expect(response).to have_http_status(:success)
          expect(response.body).to include("自分のルート")
          expect(response.body).not_to include("他人のルート")
        end
      end

      context "ルートが存在しない場合" do
        it "空の一覧が表示されること" do
          get delivery_routes_path
          expect(response).to have_http_status(:success)
        end
      end
    end
  end

  describe "GET /delivery_routes/:id" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        delivery_route = create(:delivery_route)
        get delivery_route_path(delivery_route)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      let(:user) { create(:user) }

      before { sign_in user }

      context "自分のルートの場合" do
        it "ルート名が含まれること" do
          delivery_route = create(:delivery_route, user: user, name: "テストルート")

          get delivery_route_path(delivery_route)

          expect(response).to have_http_status(:success)
          expect(response.body).to include("テストルート")
        end

        it "配達先名が含まれること" do
          delivery_route = create(:delivery_route, user: user)
          create(:delivery_point, delivery_route: delivery_route, name: "配達先A", position: 0)

          get delivery_route_path(delivery_route)

          expect(response).to have_http_status(:success)
          expect(response.body).to include("配達先A")
        end
      end

      context "他人のルートの場合" do
        it "404エラーが返されること" do
          other_user = create(:user)
          delivery_route = create(:delivery_route, user: other_user)

          get delivery_route_path(delivery_route)

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "POST /delivery_routes" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        post delivery_routes_path, params: { delivery_route: { name: "新規ルート" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      let(:user) { create(:user) }

      before { sign_in user }

      context "有効なパラメータの場合" do
        it "ルートが作成されること" do
          expect {
            post delivery_routes_path, params: {
              delivery_route: {
                name: "新規ルート",
                description: "テスト用ルート",
                date: Date.current,
                status: "draft"
              }
            }
          }.to change(DeliveryRoute, :count).by(1)
        end

        it "作成したルート名が保存されること" do
          post delivery_routes_path, params: {
            delivery_route: { name: "新規ルート", status: "draft" }
          }

          expect(DeliveryRoute.last.name).to eq "新規ルート"
        end

        it "現在のユーザーに紐付けられること" do
          post delivery_routes_path, params: {
            delivery_route: { name: "新規ルート", status: "draft" }
          }

          expect(DeliveryRoute.last.user).to eq user
        end

        it "詳細ページにリダイレクトされること" do
          post delivery_routes_path, params: {
            delivery_route: { name: "新規ルート", status: "draft" }
          }

          expect(response).to redirect_to(DeliveryRoute.last)
        end
      end

      context "無効なパラメータの場合" do
        it "ルートが作成されないこと" do
          expect {
            post delivery_routes_path, params: {
              delivery_route: { name: "" }
            }
          }.not_to change(DeliveryRoute, :count)
        end

        it "エラーが返されること" do
          post delivery_routes_path, params: {
            delivery_route: { name: "" }
          }

          expect(response).to have_http_status(:unprocessable_content)
        end
      end
    end
  end

  describe "DELETE /delivery_routes/:id" do
    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        delivery_route = create(:delivery_route)
        delete delivery_route_path(delivery_route)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログインしている場合" do
      let(:user) { create(:user) }

      before { sign_in user }

      context "自分のルートの場合" do
        it "ルートが削除されること" do
          delivery_route = create(:delivery_route, user: user)

          expect {
            delete delivery_route_path(delivery_route)
          }.to change(DeliveryRoute, :count).by(-1)
        end

        it "一覧ページにリダイレクトされること" do
          delivery_route = create(:delivery_route, user: user)

          delete delivery_route_path(delivery_route)

          expect(response).to redirect_to(delivery_routes_path)
        end

        it "関連する配達先も削除されること" do
          delivery_route = create(:delivery_route, user: user)
          create(:delivery_point, delivery_route: delivery_route, position: 0)
          create(:delivery_point, delivery_route: delivery_route, position: 1)

          expect {
            delete delivery_route_path(delivery_route)
          }.to change(DeliveryPoint, :count).by(-2)
        end
      end

      context "他人のルートの場合" do
        it "404エラーが返されること" do
          other_user = create(:user)
          delivery_route = create(:delivery_route, user: other_user)

          delete delivery_route_path(delivery_route)

          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
