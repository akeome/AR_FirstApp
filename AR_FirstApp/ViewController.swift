//
//  ViewController.swift
//  AR_FirstApp
//
//  Created by 山下優樹 on 2021/03/06.
//

import UIKit
import RealityKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView! {
        didSet {
            arView.debugOptions = [.showStatistics, .showFeaturePoints]
        }
    }
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reality Composerで作成した3Dコンテンツを表示
        let world = try! Experience.loadTempleScene()
        arView.scene.anchors.append(world)
        
        // 位置情報の初期設定
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    // リセットボタンタップ時の処理
    @IBAction func resetAction(_ sender: UIButton) {
        print("タップ", arView.scene.anchors.count)
        
        arView.scene.anchors.removeAll()

        let world = try! Experience.loadTempleScene()
        arView.scene.anchors.append(world)
    }
}

// 位置情報関連の処理
// https://dev.classmethod.jp/articles/ios11-arkit-corelocation-compass/
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("ユーザーはこのアプリケーションに関してまだ選択を行っていません")
            locationManager.requestWhenInUseAuthorization() // 起動中のみの取得許可を求める
            break
        case .denied:
            print("ローケーションサービスの設定が「無効」になっています (ユーザーによって、明示的に拒否されています）")
            // 「設定 > プライバシー > 位置情報サービス で、位置情報サービスの利用を許可して下さい」を表示する
            break
        case .restricted:
            print("このアプリケーションは位置情報サービスを使用できません(ユーザによって拒否されたわけではありません)")
            // 「このアプリは、位置情報を取得できないために、正常に動作できません」を表示する
            break
        case .authorizedAlways:
            print("常時、位置情報の取得が許可されています。")
            // 位置情報取得の開始処理
            break
        case .authorizedWhenInUse:
            print("起動時のみ、位置情報の取得が許可されています。")
            locationManager.headingFilter = kCLHeadingFilterNone
            locationManager.headingOrientation = .portrait
            locationManager.startUpdatingHeading()
            break
            
        @unknown default:
            print("未知のcaseです。")
        }
    }
    
    
    // 位置情報取得の度に呼ばれる
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // TODO: 位置情報を元に方角を判定する処理
    }
}
