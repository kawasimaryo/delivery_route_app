# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeliveryPoint, type: :model do
  describe "バリデーション" do
    describe "name" do
      context "nameが存在する場合" do
        it "有効である" do
          delivery_point = build(:delivery_point, name: "田中様宅")
          expect(delivery_point).to be_valid
        end
      end

      context "nameが空の場合" do
        it "無効である" do
          delivery_point = build(:delivery_point, name: "")
          expect(delivery_point).not_to be_valid
          expect(delivery_point.errors[:name]).to include("を入力してください")
        end
      end

      context "nameが100文字の場合" do
        it "有効である" do
          delivery_point = build(:delivery_point, name: "あ" * 100)
          expect(delivery_point).to be_valid
        end
      end

      context "nameが101文字の場合" do
        it "無効である" do
          delivery_point = build(:delivery_point, name: "あ" * 101)
          expect(delivery_point).not_to be_valid
          expect(delivery_point.errors[:name]).to include("は100文字以内で入力してください")
        end
      end
    end

    describe "address" do
      context "addressが500文字の場合" do
        it "有効である" do
          delivery_point = build(:delivery_point, address: "あ" * 500)
          expect(delivery_point).to be_valid
        end
      end

      context "addressが501文字の場合" do
        it "無効である" do
          delivery_point = build(:delivery_point, address: "あ" * 501)
          expect(delivery_point).not_to be_valid
          expect(delivery_point.errors[:address]).to include("は500文字以内で入力してください")
        end
      end
    end

    describe "latitude" do
      context "latitudeが-90の場合" do
        it "有効である" do
          delivery_point = build(:delivery_point, latitude: -90)
          expect(delivery_point).to be_valid
        end
      end

      context "latitudeが90の場合" do
        it "有効である" do
          delivery_point = build(:delivery_point, latitude: 90)
          expect(delivery_point).to be_valid
        end
      end

      context "latitudeが-91の場合" do
        it "無効である" do
          delivery_point = build(:delivery_point, latitude: -91)
          expect(delivery_point).not_to be_valid
        end
      end

      context "latitudeが91の場合" do
        it "無効である" do
          delivery_point = build(:delivery_point, latitude: 91)
          expect(delivery_point).not_to be_valid
        end
      end

      context "latitudeがnilの場合" do
        it "有効である" do
          delivery_point = build(:delivery_point, latitude: nil)
          expect(delivery_point).to be_valid
        end
      end
    end

    describe "longitude" do
      context "longitudeが-180の場合" do
        it "有効である" do
          delivery_point = build(:delivery_point, longitude: -180)
          expect(delivery_point).to be_valid
        end
      end

      context "longitudeが180の場合" do
        it "有効である" do
          delivery_point = build(:delivery_point, longitude: 180)
          expect(delivery_point).to be_valid
        end
      end

      context "longitudeが-181の場合" do
        it "無効である" do
          delivery_point = build(:delivery_point, longitude: -181)
          expect(delivery_point).not_to be_valid
        end
      end

      context "longitudeが181の場合" do
        it "無効である" do
          delivery_point = build(:delivery_point, longitude: 181)
          expect(delivery_point).not_to be_valid
        end
      end
    end

    describe "position" do
      context "positionが0の場合" do
        it "有効である" do
          delivery_point = build(:delivery_point, position: 0)
          expect(delivery_point).to be_valid
        end
      end

      context "positionが負の数の場合" do
        it "無効である" do
          delivery_point = build(:delivery_point, position: -1)
          expect(delivery_point).not_to be_valid
        end
      end
    end
  end

  describe "#geocoded?" do
    context "latitudeとlongitudeが両方設定されている場合" do
      it "trueを返す" do
        delivery_point = build(:delivery_point, latitude: 35.6762, longitude: 139.6503)
        expect(delivery_point.geocoded?).to be true
      end
    end

    context "latitudeのみ設定されている場合" do
      it "falseを返す" do
        delivery_point = build(:delivery_point, latitude: 35.6762, longitude: nil)
        expect(delivery_point.geocoded?).to be false
      end
    end

    context "longitudeのみ設定されている場合" do
      it "falseを返す" do
        delivery_point = build(:delivery_point, latitude: nil, longitude: 139.6503)
        expect(delivery_point.geocoded?).to be false
      end
    end

    context "両方nilの場合" do
      it "falseを返す" do
        delivery_point = build(:delivery_point, latitude: nil, longitude: nil)
        expect(delivery_point.geocoded?).to be false
      end
    end
  end
end
