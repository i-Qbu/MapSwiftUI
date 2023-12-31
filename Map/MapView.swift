//
//  MapView.swift
//  Map
//
//  Created by 渡辺大智 on 2023/12/31.
//

import SwiftUI
import MapKit

enum MapType {
    case standard
    case satellite
    case hybrid
}

struct MapView: View {
    
    let searchKey: String
    let mapType: MapType
    // 緯度経度の構造体プロパティ
    @State var targetCoordinate = CLLocationCoordinate2D()
    
    // 表示するマップの位置
    @State var cameraPosition: MapCameraPosition = .automatic
    
    var mapStyle: MapStyle {
        switch mapType {
        case .standard:
            return MapStyle.standard()
        case .satellite:
            return MapStyle.imagery()
        case .hybrid:
            return MapStyle.hybrid()
        }
    }
    
    var body: some View {
        Map(position: $cameraPosition) {
            // ピンを表示
            Marker(searchKey, coordinate: targetCoordinate)
        }
        .mapStyle(mapStyle)
        .onChange(of: searchKey, initial: true) { oldValue, newValue in
            print("検索キーワード：\(newValue)")
            // Mapの検索方法
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = newValue
            let search = MKLocalSearch(request: request)
            
            search.start { response, error in
                // 複数の検索候補が返ってくるので，その最初を取り出す(アンラップ)
                if let mapItems = response?.mapItems,
                   let mapItem = mapItems.first {
                    
                    targetCoordinate = mapItem.placemark.coordinate
                    
                    print("緯度経度：\(targetCoordinate)")
                    
                    cameraPosition = .region(MKCoordinateRegion(
                        center: targetCoordinate,
                        latitudinalMeters: 500,
                        longitudinalMeters: 500))
                }
            }
        }
    }
}

#Preview {
    MapView(searchKey: "北見駅", mapType: .standard)
}
