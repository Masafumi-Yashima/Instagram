//
//  TabBarController.swift
//  Instagram
//
//  Created by YashimaMasafumi on 2021/03/03.
//

import UIKit
//Firebase:リアルタイムにデータを同期する必要があるサービスに適しているサービス
//サーバーに対してデータを読み書きできる
//アカウントを管理する機能を持つ
import Firebase

class TabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        //タブバーの背景色
        self.tabBar.barTintColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        //UITabBarControllerDelegateのプロトコルのメソッドをこのクラスで処理する
        self.delegate = self

        // Do any additional setup after loading the view.
    }
    
    //タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理する
    //指定されたtabBarControllerをアクティブにする必要があるかどうか
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        //viewControllerがImageSelectViewControllerならモーダル遷移
        if viewController is ImageSelectViewController {
            //ImageSelectViewControllerはタブ切り替えではなくモーダル画面遷移する
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            //ViewControllerをモーダルに表示する
            present(imageSelectViewController, animated: true)
            //現在のタブをアクティブのままにする場合
            return false
        } else {
            //その他のViewControllerは通常のタブ切り替えを実施
            //return true ビューコントローラのタブを選択する必要がある場合
            return true
        }
    }
    
    //TabBarControllerが表示された時の処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //currentUserがnilならログインしていない
        if Auth.auth().currentUser == nil {
            //ログインしていない時の処理
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(loginViewController!, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
