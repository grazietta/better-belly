//
//  Firebase.swift
//  better-belly
//
//  Created by Grazietta Hof on 2018-09-15.
//  Copyright © 2018 Ansar Khan. All rights reserved.
//

import Firebase

class Firebase {
    
    static var ref: DatabaseReference = {
        FirebaseApp.configure()
        return Database.database().reference()
    }()
    
    static var userRef = ref.childByAutoId()
}




