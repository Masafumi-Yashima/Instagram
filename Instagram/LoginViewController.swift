//
//  LoginViewController.swift
//  Instagram
//
//  Created by YashimaMasafumi on 2021/03/02.
//

import UIKit
import Firebase
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailAdressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    
    //ログインボタンをタップした時に呼ばれるメソッド
    @IBAction func handleLoginButton(_ sender: Any) {
        //adress,passwardがnil（何もない）でなかったらaddress,passwardを格納する（String型の器を作る）
        if let address = mailAdressTextField.text, let passward = passwordTextField.text {
            //アドレスとパスワードいずれかでも入力されていない（String型の器が空なら）場合何もしない
            if address.isEmpty || passward.isEmpty {
                SVProgressHUD.showError(withStatus: "必須項目を入力してください")
                return
            }
            
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            Auth.auth().signIn(withEmail: address, password: passward){ authResult, error in
                if let error = error {
                    print("DEBUG_PRINT:" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました")
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                
                //HUDを消す
                SVProgressHUD.dismiss()
                
                //画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //アカウント作成ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        if let address = mailAdressTextField.text, let passwaord = passwordTextField.text, let displayName = displayNameTextField.text {
            //アドレス、パスワード、表示名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || passwaord.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                SVProgressHUD.showError(withStatus: "必須項目を入力してください")
                return
            }
            
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            //アドレスとパスワードでユーザー作成。ユーザー作成に成功すると自動的にログインする
            Auth.auth().createUser(withEmail: address, password: passwaord){ authResult, error in
                if let error = error {
                    //エラーがあったら原因をprintしてreturnすることで以降の処理を実行せず終了する
                    print("DEBUG_PRINT:" + error.localizedDescription)
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました")
                    return
                }
                print("DEBUG_PRINT: ユーザーの作成に成功しました。")
                
                //表示名を設定する
                //Auth.auth().currentUserで現在サインインしているユーザーを取得、ユーザーがサインインしていない場合はnilを返す
                let user = Auth.auth().currentUser
                //userがnilでなかったら
                if let user = user {
                    //createProfileChangeRequest()でユーザーのプロファイルを更新する
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    //commitChangeで更新する
                    changeRequest.commitChanges { error in
                        if let error = error {
                            //プロフィールの更新でエラーが発生
                            print("DEBUG_PRINT:" + error.localizedDescription)
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました")
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)] の設定に成功しました。")
                        
                        //HUDを消す
                        SVProgressHUD.dismiss()
                        
                        //画面を閉じてタブ画面に戻る
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
