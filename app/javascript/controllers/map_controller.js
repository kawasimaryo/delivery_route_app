import { Controller } from "@hotwired/stimulus"

// Google Maps表示用コントローラー
// data-controller="map" で有効化
export default class extends Controller {
  static targets = ["container", "infoPanel"]
  static values = {
    apiKey: String,
    points: Array
  }

  connect() {
    if (!this.hasApiKeyValue || this.apiKeyValue === "") {
      this.showError("Google Maps APIキーが設定されていません")
      return
    }

    this.markers = []
    this.infoWindow = null
    this.loadGoogleMapsAPI()
  }

  disconnect() {
    // クリーンアップ
    if (this.infoWindow) {
      this.infoWindow.close()
    }
  }

  loadGoogleMapsAPI() {
    // 既に読み込み済みの場合
    if (window.google && window.google.maps) {
      this.initMap()
      return
    }

    // Google Maps APIスクリプトを動的に読み込み
    const script = document.createElement("script")
    script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&callback=Function.prototype`
    script.async = true
    script.defer = true
    script.onload = () => this.initMap()
    script.onerror = () => this.showError("Google Maps APIの読み込みに失敗しました")
    document.head.appendChild(script)
  }

  initMap() {
    const points = this.pointsValue

    // デフォルトの中心点（東京）
    let center = { lat: 35.6762, lng: 139.6503 }
    let zoom = 12

    // 座標のある配達先から中心点を計算
    const geocodedPoints = points.filter(p => p.latitude && p.longitude)
    if (geocodedPoints.length > 0) {
      const bounds = this.calculateBounds(geocodedPoints)
      center = bounds.center
    }

    // 地図を初期化
    this.map = new google.maps.Map(this.containerTarget, {
      center: center,
      zoom: zoom,
      mapTypeControl: true,
      streetViewControl: false,
      fullscreenControl: true,
      zoomControl: true,
      styles: this.mapStyles()
    })

    // InfoWindowを作成
    this.infoWindow = new google.maps.InfoWindow()

    // マーカーを配置
    this.placeMarkers(points)

    // 全マーカーが見えるようにフィット
    if (geocodedPoints.length > 0) {
      this.fitBounds(geocodedPoints)
    }
  }

  placeMarkers(points) {
    points.forEach((point, index) => {
      if (!point.latitude || !point.longitude) return

      const position = { lat: point.latitude, lng: point.longitude }
      const orderNumber = index + 1

      // カスタムマーカーを作成
      const marker = new google.maps.Marker({
        position: position,
        map: this.map,
        title: point.name,
        label: {
          text: String(orderNumber),
          color: "#ffffff",
          fontSize: "14px",
          fontWeight: "bold"
        },
        icon: this.getMarkerIcon(point.status)
      })

      // マーカークリック時の処理
      marker.addListener("click", () => {
        this.showPointInfo(point, marker, orderNumber)
      })

      this.markers.push(marker)
    })
  }

  getMarkerIcon(status) {
    const colors = {
      pending: "#3b82f6",    // 青：未配達
      delivered: "#22c55e",  // 緑：配達済み
      absent: "#ef4444"      // 赤：不在
    }

    const color = colors[status] || colors.pending

    return {
      path: google.maps.SymbolPath.CIRCLE,
      fillColor: color,
      fillOpacity: 1,
      strokeColor: "#ffffff",
      strokeWeight: 2,
      scale: 15
    }
  }

  showPointInfo(point, marker, orderNumber) {
    const statusLabels = {
      pending: "未配達",
      delivered: "配達済み",
      absent: "不在"
    }

    const statusClasses = {
      pending: "status-pending",
      delivered: "status-delivered",
      absent: "status-absent"
    }

    const content = `
      <div class="map-info-window">
        <div class="info-header">
          <span class="info-order">${orderNumber}</span>
          <span class="info-name">${this.escapeHtml(point.name)}</span>
        </div>
        <div class="info-status ${statusClasses[point.status]}">
          ${statusLabels[point.status]}
        </div>
        ${point.address ? `<div class="info-address">${this.escapeHtml(point.address)}</div>` : ""}
        ${point.memo ? `<div class="info-memo">${this.escapeHtml(point.memo)}</div>` : ""}
        <div class="info-actions">
          <a href="${point.editUrl}" class="info-link">編集</a>
        </div>
      </div>
    `

    this.infoWindow.setContent(content)
    this.infoWindow.open(this.map, marker)

    // 情報パネルも更新（もしあれば）
    if (this.hasInfoPanelTarget) {
      this.infoPanelTarget.innerHTML = content
      this.infoPanelTarget.classList.add("active")
    }
  }

  calculateBounds(points) {
    let minLat = Infinity, maxLat = -Infinity
    let minLng = Infinity, maxLng = -Infinity

    points.forEach(point => {
      minLat = Math.min(minLat, point.latitude)
      maxLat = Math.max(maxLat, point.latitude)
      minLng = Math.min(minLng, point.longitude)
      maxLng = Math.max(maxLng, point.longitude)
    })

    return {
      center: {
        lat: (minLat + maxLat) / 2,
        lng: (minLng + maxLng) / 2
      },
      bounds: { minLat, maxLat, minLng, maxLng }
    }
  }

  fitBounds(points) {
    if (points.length === 0) return

    if (points.length === 1) {
      this.map.setCenter({ lat: points[0].latitude, lng: points[0].longitude })
      this.map.setZoom(15)
      return
    }

    const bounds = new google.maps.LatLngBounds()
    points.forEach(point => {
      bounds.extend({ lat: point.latitude, lng: point.longitude })
    })
    this.map.fitBounds(bounds, { padding: 50 })
  }

  showError(message) {
    this.containerTarget.innerHTML = `
      <div class="map-error">
        <p>${message}</p>
      </div>
    `
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }

  mapStyles() {
    // シンプルで見やすいスタイル
    return [
      {
        featureType: "poi",
        elementType: "labels",
        stylers: [{ visibility: "off" }]
      }
    ]
  }

  // マーカーの表示/非表示を切り替え
  toggleMarkers(event) {
    const status = event.target.dataset.status
    this.markers.forEach((marker, index) => {
      const point = this.pointsValue[index]
      if (status === "all" || point.status === status) {
        marker.setVisible(true)
      } else {
        marker.setVisible(false)
      }
    })
  }
}
