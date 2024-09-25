import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var testMapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    var selectDetails: [String] = ["", "", ""]
  
    
    // 店舗名、位置情報、距離を格納する配列
    var storeNames: [String] = []
    var storeCoordinates: [(latitude: CLLocationDegrees, longitude: CLLocationDegrees)] = []
    var storeDistances: [Double] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // selectDetails[2]をDoubleに変換して保持する
        // selectDetails[2] をトリムして Double に変換
        if let distanceStr = Double(selectDetails[2].trimmingCharacters(in: .whitespacesAndNewlines)) {
            let maxDistance = distanceStr
            print("変換後のmaxDistance: \(maxDistance)")
        } else {
            print("selectDetails[2] の値を Double に変換できません")
        }
        
        
        
        print("Selected Details after transition: \(selectDetails)")

        
        // CLLocationManagerの初期化
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // 位置情報の許可をリクエスト
        locationManager.requestWhenInUseAuthorization()
        
        // マップの初期表示設定（デフォルトの場所など）
        let center = CLLocationCoordinate2D(latitude: 35.690553, longitude: 139.699579)
        let span = MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003)
        let region = MKCoordinateRegion(center: center, span: span)
        testMapView.setRegion(region, animated: true)
        
        // ユーザーの現在地を表示
        testMapView.showsUserLocation = true
        print("Selected Details: \(selectDetails)")
    }
    
    // 位置情報の権限が変更されたときに呼ばれる
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    // 位置情報が更新されたときに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let currentLocation = location.coordinate
            
            // マップの中心を現在地に設定
            let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 500, longitudinalMeters: 500)
            testMapView.setRegion(region, animated: true)
            
            // 検索リクエストの設定
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = selectDetails[0] // カテゴリ検索
            request.region = testMapView.region
            
            let localSearch: MKLocalSearch = MKLocalSearch(request: request)
            localSearch.start { (response, error) in
                if let error = error {
                    print("検索エラー: \(error.localizedDescription)")
                    return
                }
                guard let mapItems = response?.mapItems else { return }
                
                // selectDetails[2] を Double に変換
                let maxDistance = Double(self.selectDetails[2]) ?? 0.0
              
                
                for placemark in mapItems {
                    // 店舗名と位置情報を配列に追加
                    if let name = placemark.name {
                        self.storeNames.append(name)
                        self.storeCoordinates.append((latitude: placemark.placemark.coordinate.latitude, longitude: placemark.placemark.coordinate.longitude))
                    }
                    
                    // 現在地から店舗までの距離を計算
                    let storeLocation = CLLocation(latitude: placemark.placemark.coordinate.latitude, longitude: placemark.placemark.coordinate.longitude)
                    let distance = storeLocation.distance(from: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude))
                    self.storeDistances.append(distance)
                    
                    // デバッグ用に距離とselectDetails[2]の値を表示
                    print("店舗名: \(placemark.name ?? "")")
                    print("距離: \(distance) メートル")
                    print("設定された距離条件: \(maxDistance) * 1000 = \(maxDistance * 1000)")
                    
                    // 距離がmaxDistance * 1000以内ならピンを立てる
                    if distance <= maxDistance * 1000 {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = placemark.placemark.coordinate
                        annotation.title = placemark.name
                        self.testMapView.addAnnotation(annotation)
                    } else {
                        print("この店舗は条件外です")
                    }
                }
                
                // 検索結果の配列を表示（デバッグ用）
                print("検索にかかった店舗名の一覧: \(self.storeNames)")
                print("各店舗の位置情報 (緯度・経度): \(self.storeCoordinates)")
                print("各店舗までの距離 (メートル): \(self.storeDistances)")
            }
            
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました: \(error.localizedDescription)")
    }
    
}
