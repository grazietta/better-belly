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
//        userRef.child("dates").child("someDate").child("highCounter").setValue("5")
//        userRef.child("dates").child("someOtherDate").child("highCounter").setValue("6")
        
        let refHandle = Firebase.userRef.child("dates").queryLimited(toFirst: 5).observe(DataEventType.value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let snap = enumerator.nextObject() as? DataSnapshot {
                let secondEnumerator = snap.children
                while let snap = secondEnumerator.nextObject() as? DataSnapshot {
                    print(snap.value!)
                }
            }
        })
    }
    
    static func fetchLowCounts() {
//        userRef.child("dates").child("someDate").child("highCounter").setValue("5")
//        userRef.child("dates").child("someOtherDate").child("highCounter").setValue("6")
        
        let refHandle = Firebase.userRef.child("dates").queryLimited(toFirst: 5).observe(DataEventType.value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let snap = enumerator.nextObject() as? DataSnapshot {
                let secondEnumerator = snap.children
                while let snap = secondEnumerator.nextObject() as? DataSnapshot {
                    print(snap.value!)
                }
            }
        })
        
    }
    
    static func incrementHighCounter() {
        
    }
    
    static func incrementLowCounter() {
        
    }
    
    static func fetchDates() {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        print(day)
        print(month)
        print(year)
        
    }
}




