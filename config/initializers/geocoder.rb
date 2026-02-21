# frozen_string_literal: true

if Rails.env.test?
  # テスト環境ではジオコーディングをスキップ
  Geocoder.configure(
    lookup: :test
  )

  Geocoder::Lookup::Test.set_default_stub(
    [
      {
        "coordinates" => [ 35.6762, 139.6503 ],
        "address" => "東京都渋谷区",
        "city" => "渋谷区",
        "country" => "日本"
      }
    ]
  )
else
  Geocoder.configure(
    lookup: :google,
    api_key: ENV["GEOCODING_API_KEY"],
    units: :km,
    timeout: 5,
    language: :ja,
    region: "jp",
    use_https: true
  )
end
