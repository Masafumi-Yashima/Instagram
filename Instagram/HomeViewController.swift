//
//  HomeViewController.swift
//  Instagram
//
//  Created by YashimaMasafumi on 2021/03/02.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    //投稿データを格納する配列
    var postArray: [PostData] = []
    
    //Firestoreのデータ更新の監視を行うためのリスナー
    var listener: ListenerRegistration?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //セル内のボタンのアクションをソースコードで設定する
        //hundleEventの第一引数にはタップされたUIButtonのインスタンスが格納され、第二引数にはUIEvent型のタップイベントが格納される
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを登録する
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
    }
    
    //投稿データを読み込む
    //Firestoreからデータを取得すると、QueryDocumentSnapshotクラスのデータが渡される
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewVillAppear")
        //ログイン済みか確認（ログインしていれば）
        if Auth.auth().currentUser != nil {
            //listenerを登録して投稿データの更新を監視する（参照場所と日付順にソート）（デフォルトではドキュメントIDの昇順で取得）（orderで並び替え,descending=trueで降順に）
            let postRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            //addSnapshotListenerのクロージャーは投稿データが追加・更新されるたびに呼び出される
            //querySnapshotに最新のデータが入っている
            listener = postRef.addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。\(error)")
                    return
                }
                //取得したdocumentを元にPostDataを作成して、postArrayの配列にする
                //mapは配列内の要素に処理を適用し、その処理を施した配列を使いたい場合に使用する
                self.postArray = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT: document取得\(document.documentID)")
                    let postData = PostData(document: document)
                    return postData
                }
                //TableViewの表示を更新する
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDissapear")
        //listenerを削除して監視を停止する
        listener?.remove()
    }
    
    //セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました")
        
        //タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        //タップされた座標（TableView内の座標）を割り出す
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //likesを更新する
        if let myid = Auth.auth().currentUser?.uid {
            //更新データを作成する
            var updateValue: FieldValue
            if postData.isLiked {
                //すでにいいねしている場合は、いいね削除のためmyidを取り除く更新データを作成
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                //今回新たにいいねを押した場合は、myidを追加する更新データを作成
                updateValue = FieldValue.arrayUnion([myid])
            }
            //likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes":updateValue])
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
