import UIKit

class SelectKeyWordViewController: UIViewController {
    @IBOutlet weak var categorySegumentControl: UISegmentedControl!
    @IBOutlet weak var keyWordSegumentControl: UISegmentedControl!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var selectDetails: [String] = ["米", "高タンパク", "5"]  // 初期値を設定（配列[0], [1], [2]を確保）

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UISliderの設定
        distanceSlider.minimumValue = 5
        distanceSlider.maximumValue = 15
        distanceSlider.value = 5  // 初期値を5kmに設定

        // スライダーの値が変わった時のアクション
        distanceSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    @IBAction func categorysegmentedControl(_ sender: UISegmentedControl) {
        // categoryをselectDetails[0]に代入
        selectDetails[0] = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""
    }
    
    @IBAction func keyWordsegmentedControl(_ sender: UISegmentedControl) {
        // keyWordをselectDetails[1]に代入
        selectDetails[1] = sender.titleForSegment(at: sender.selectedSegmentIndex) ?? ""
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        // スライダーの現在の値を取得
        let sliderValue = sender.value

        // 値を5km, 10km, 15km
        if sliderValue < 7.5 {
            sender.value = 5
        } else if sliderValue < 12.5 {
            sender.value = 10
        } else {
            sender.value = 15
        }

        // 距離をselectDetails[2] にセット
        distanceLabel.text = "\(Int(sender.value)) "
        selectDetails[2] = distanceLabel.text ?? ""  // Optionalのためnilチェック
    }

    @IBAction func search() {
  
        // 検索ボタン押下時に配列を表示
       // print("Selected Details: \(selectDetails)")
        print("Debug Selected Details: \(selectDetails)") // 確認用
        
        // MapViewControllerに遷移する
           if let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
               // キーワードを渡す
               mapVC.selectDetails = selectDetails
               
               // 画面遷移
              // navigationController?.pushViewController(mapVC, animated: true)
           }
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MapViewController",
           let mapVC = segue.destination as? MapViewController {
            mapVC.selectDetails = selectDetails
        }
    }
}
