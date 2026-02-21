# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeliveryRoute, type: :model do
  describe "バリデーション" do
    describe "name" do
      context "nameが存在する場合" do
        it "有効である" do
          delivery_route = build(:delivery_route, name: "仙台市内ルート")
          expect(delivery_route).to be_valid
        end
      end

      context "nameが空の場合" do
        it "無効である" do
          delivery_route = build(:delivery_route, name: "")
          expect(delivery_route).not_to be_valid
          expect(delivery_route.errors[:name]).to include("を入力してください")
        end
      end

      context "nameが100文字の場合" do
        it "有効である" do
          delivery_route = build(:delivery_route, name: "あ" * 100)
          expect(delivery_route).to be_valid
        end
      end

      context "nameが101文字の場合" do
        it "無効である" do
          delivery_route = build(:delivery_route, name: "あ" * 101)
          expect(delivery_route).not_to be_valid
          expect(delivery_route.errors[:name]).to include("は100文字以内で入力してください")
        end
      end
    end

    describe "description" do
      context "descriptionが1000文字の場合" do
        it "有効である" do
          delivery_route = build(:delivery_route, description: "あ" * 1000)
          expect(delivery_route).to be_valid
        end
      end

      context "descriptionが1001文字の場合" do
        it "無効である" do
          delivery_route = build(:delivery_route, description: "あ" * 1001)
          expect(delivery_route).not_to be_valid
          expect(delivery_route.errors[:description]).to include("は1000文字以内で入力してください")
        end
      end
    end

    describe "status" do
      context "statusが存在する場合" do
        it "有効である" do
          delivery_route = build(:delivery_route, status: :draft)
          expect(delivery_route).to be_valid
        end
      end
    end
  end

  describe "ステータス管理" do
    describe "enum" do
      context "draftステータスの場合" do
        it "status_draft?がtrueを返す" do
          delivery_route = build(:delivery_route, status: :draft)
          expect(delivery_route.status_draft?).to be true
          expect(delivery_route.status_confirmed?).to be false
          expect(delivery_route.status_completed?).to be false
        end
      end

      context "confirmedステータスの場合" do
        it "status_confirmed?がtrueを返す" do
          delivery_route = build(:delivery_route, status: :confirmed)
          expect(delivery_route.status_confirmed?).to be true
          expect(delivery_route.status_draft?).to be false
          expect(delivery_route.status_completed?).to be false
        end
      end

      context "completedステータスの場合" do
        it "status_completed?がtrueを返す" do
          delivery_route = build(:delivery_route, status: :completed)
          expect(delivery_route.status_completed?).to be true
          expect(delivery_route.status_draft?).to be false
          expect(delivery_route.status_confirmed?).to be false
        end
      end
    end

    describe "#progress_percentage" do
      context "配達先がない場合" do
        it "0.0を返す" do
          delivery_route = create(:delivery_route)
          expect(delivery_route.progress_percentage).to eq 0.0
        end
      end

      context "配達先が3件あり1件が配達済みの場合" do
        it "33.3を返す" do
          delivery_route = create(:delivery_route)
          create(:delivery_point, delivery_route: delivery_route, status: :delivered, position: 0)
          create(:delivery_point, delivery_route: delivery_route, status: :pending, position: 1)
          create(:delivery_point, delivery_route: delivery_route, status: :pending, position: 2)

          expect(delivery_route.progress_percentage).to eq 33.3
        end
      end

      context "配達先が2件あり全て配達済みの場合" do
        it "100.0を返す" do
          delivery_route = create(:delivery_route)
          create(:delivery_point, delivery_route: delivery_route, status: :delivered, position: 0)
          create(:delivery_point, delivery_route: delivery_route, status: :delivered, position: 1)

          expect(delivery_route.progress_percentage).to eq 100.0
        end
      end
    end

    describe "#total_points" do
      context "配達先が3件の場合" do
        it "3を返す" do
          delivery_route = create(:delivery_route)
          create_list(:delivery_point, 3, delivery_route: delivery_route)

          expect(delivery_route.total_points).to eq 3
        end
      end
    end

    describe "#delivered_points" do
      context "配達済みが2件の場合" do
        it "2を返す" do
          delivery_route = create(:delivery_route)
          create(:delivery_point, delivery_route: delivery_route, status: :delivered, position: 0)
          create(:delivery_point, delivery_route: delivery_route, status: :delivered, position: 1)
          create(:delivery_point, delivery_route: delivery_route, status: :pending, position: 2)

          expect(delivery_route.delivered_points).to eq 2
        end
      end
    end
  end
end
