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
        //commentsを更新する
        if let myid = Auth.auth().currentUser?.uid {
            var updateValue: FieldValue
            let commentText = commentTextField.text!
            let comments = [myid:commentText] as [String:String]
            updateValue = FieldValue.arrayUnion([comments])
            //commentsに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["comments":updateValue])
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
