//
//  CommentViewController.swift
//  Instagram
//
//  Created by YashimaMasafumi on 2021/03/17.
//

import UIKit

class CommentViewController: UIViewController {
    @IBOutlet weak var commentTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleCommentButton(_ sender: Any) {
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
