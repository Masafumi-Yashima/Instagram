//
//  PostData.swift
//  Instagram
//
//  Created by YashimaMasafumi on 2021/03/09.
//

import Foundation
import Firebase

class PostData: NSObject {
    var id: String
    var name: String?
    var caption: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    var comments: [Comment] = []
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let postDic = document.data()
        
        //Any型をString型にダウンキャストする
        self.name = postDic["name"] as? String
        
        self.caption = postDic["caption"] as? String
        
        let timestamp = postDic["date"] as? Timestamp
        self.date = timestamp?.dateValue()
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        if let myid = Auth.auth().currentUser?.uid {
            //likesの配列の中にmyidが含まれているかチェックすることで、自分がいいねを推しているか判断
            if self.likes.firstIndex(of: myid) != nil {
                //myidがあれば、いいねを押していると認識する
                self.isLiked = true
            }
        }
        
        if let comments = postDic["comments"] as? [Comment] {
            self.comments = comments
        }
    }
}

class Comment: NSObject {
    var id: String = ""
    var name: String?
    var date: Date?
    var comment: String?
}
