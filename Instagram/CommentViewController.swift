//
//  CommentViewController.swift
//  Instagram
//
//  Created by YashimaMasafumi on 2021/03/17.
//

import UIKit
import Firebase

class CommentViewController: UIViewController {
    @IBOutlet weak var commentTextField: UITextView!
    
    //投稿データを格納する配列
    var postData: PostData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TextViewに枠線をつける
        commentTextField.layer.borderWidth = 1.0
        commentTextField.layer.cornerRadius = 5.0

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleCommentButton(_ sender: Any) {
        print("DEBUG_PRINT: コメントを投稿しました")
    
        if Auth.auth().currentUser != nil {
            var updateValue: FieldValue
            //コメント者のユーザー名
            let name = Auth.auth().currentUser?.displayName
            //コメントのデータを格納する
            let commentsArray = [
                "name":name!,
                "comment":self.commentTextField.text!,
                "date":Timestamp(date: Date())
            ] as [String:Any]
            updateValue = FieldValue.arrayUnion([commentsArray])
            let postRef = Firestore.firestore().collection(Const.PostPath).document(self.postData.id)
            postRef.updateData(["comments":updateValue])
            print("DEBUG_PRINT:新規フィールド")
        
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
        //ホーム画面に戻る
        self.dismiss(animated: true, completion: nil)
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
