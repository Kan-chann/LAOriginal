import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var testMapView: MKMapView!
    
    var locationManager: CLLocationManager!
    
    var selectDetails: [String] = ["", "", ""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Selected Details after transition: \(selectDetails)") // 確認用
        
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
            // 許可を求める
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            // 許可がない場合、アクションを行わない
            break
        case .authorizedAlways, .authorizedWhenInUse:
            // 許可された場合、位置情報の更新を開始
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    // 位置情報が更新されたときに呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            // 現在地の座標を取得
            let currentLocation = location.coordinate
           
            
            // マップの中心を現在地に設定
            let region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 500, longitudinalMeters: 500)
            testMapView.setRegion(region, animated: true)
            
            // 現在地にピンを立てる
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = currentLocation
//            annotation.title = "現在地"
//            testMapView.addAnnotation(annotation)
            
            // 位置情報の更新を停止
            manager.stopUpdatingLocation()
        }
    }
    
    // 位置情報の取得に失敗したときに呼ばれる
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました: \(error.localizedDescription)")
    }
}
