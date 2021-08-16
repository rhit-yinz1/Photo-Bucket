//
//  PB.swift
//  Photo Bucket
//
//  Created by Theo Yin on 8/8/21.
//

import Foundation
import Firebase
class PB {
    var url: String
    var caption: String
    var id: String?
    
    
    
    init(url: String, caption: String){
        self.url = url
        self.caption = caption
    }
    
    init(documentSnapshot: DocumentSnapshot) {
        self.id = documentSnapshot.documentID
        let data = documentSnapshot.data()!
        self.url = data["imgUrl"] as! String
        self.caption = data["imgCaption"] as! String
    }
}
