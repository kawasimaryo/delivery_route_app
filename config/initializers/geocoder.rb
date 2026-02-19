# frozen_string_literal: true

Geocoder.configure(
  lookup: :google,
  api_key: ENV["GEOCODING_API_KEY"],
  units: :km,
  timeout: 5,
  language: :ja,
  region: "jp",
  use_https: true
)
