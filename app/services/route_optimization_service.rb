# frozen_string_literal: true

require "net/http"
require "json"

class RouteOptimizationService
  class OptimizationError < StandardError; end

  DIRECTIONS_API_URL = "https://maps.googleapis.com/maps/api/directions/json"
  MAX_WAYPOINTS = 25

  def initialize(delivery_route)
    @delivery_route = delivery_route
    @api_key = ENV["GEOCODING_API_KEY"]
  end

  def call
    validate_api_key!
    points = geocoded_points

    return success_result(nil) if points.size < 2

    validate_waypoint_limit!(points)

    response = request_directions(points)
    update_positions(points, response[:waypoint_order])

    success_result(response[:polyline])
  rescue OptimizationError => e
    error_result(e.message)
  rescue StandardError => e
    Rails.logger.error("RouteOptimizationService error: #{e.message}")
    error_result("ルート最適化中にエラーが発生しました")
  end

  private

  def validate_api_key!
    raise OptimizationError, "Google Maps APIキーが設定されていません" if @api_key.blank?
  end

  def validate_waypoint_limit!(points)
    return if points.size <= MAX_WAYPOINTS

    raise OptimizationError, "配達先が#{MAX_WAYPOINTS}件を超えています（現在#{points.size}件）"
  end

  def geocoded_points
    @delivery_route.delivery_points.ordered.select(&:geocoded?)
  end

  def request_directions(points)
    origin = points.first
    destination = points.last
    waypoints = points[1...-1]

    params = build_params(origin, destination, waypoints)
    response = fetch_directions(params)

    parse_response(response)
  end

  def build_params(origin, destination, waypoints)
    params = {
      origin: "#{origin.latitude},#{origin.longitude}",
      destination: "#{destination.latitude},#{destination.longitude}",
      key: @api_key,
      language: "ja"
    }

    if waypoints.any?
      waypoint_str = waypoints.map { |p| "#{p.latitude},#{p.longitude}" }.join("|")
      params[:waypoints] = "optimize:true|#{waypoint_str}"
    end

    params
  end

  def fetch_directions(params)
    uri = URI(DIRECTIONS_API_URL)
    uri.query = URI.encode_www_form(params)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.open_timeout = 10
    http.read_timeout = 10

    request = Net::HTTP::Get.new(uri)
    response = http.request(request)

    JSON.parse(response.body)
  end

  def parse_response(data)
    unless data["status"] == "OK"
      error_message = data["error_message"] || "Directions APIエラー: #{data['status']}"
      raise OptimizationError, error_message
    end

    route = data["routes"].first
    {
      waypoint_order: route["waypoint_order"] || [],
      polyline: route["overview_polyline"]["points"]
    }
  end

  def update_positions(points, waypoint_order)
    return if points.size <= 2

    ActiveRecord::Base.transaction do
      # 始点は常にposition 0
      points.first.update!(position: 0)

      # 中間点を最適化順序で更新
      waypoint_order.each_with_index do |original_index, new_index|
        points[original_index + 1].update!(position: new_index + 1)
      end

      # 終点は最後
      points.last.update!(position: points.size - 1)
    end
  end

  def success_result(polyline)
    { success: true, polyline: polyline }
  end

  def error_result(message)
    { success: false, error: message }
  end
end
