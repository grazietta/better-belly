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
    
    static var userRef = ref.child("Users").childByAutoId()

    static func fetchHighCounts() {
      userRef.child("dates").child("ingredients").setValue("sugar")
        
//        let refHandle = Firebase.userRef.child("dates").queryLimited(toFirst: 5).observe(DataEventType.value, with: { (snapshot) in
//            for date in snapshot.children.allObjects as! [DataSnapshot] {
//                print(date)
//            }
//        })
    }
    
    func fetchLowCounts() {
        
        
    }
    
    func incrementHighCounter() {
        
    }
    
    func incrementLowCounter() {
        
    }
    
    func fetchDates() {
      
    }
}




