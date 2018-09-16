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
    
    static func fetchHighCounts() -> [String : Int] {
        var dict: Dictionary = [String: Int]()
        
        Firebase.userRef.child("dates").queryLimited(toFirst: 5).observe(DataEventType.value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let date = enumerator.nextObject() as? DataSnapshot {
                let secondEnumerator = date.children
                while let counter = secondEnumerator.nextObject() as? DataSnapshot {
                    if counter.key == "highCounter" {
                        if let value = ((counter.value as? NSString)) {
                            dict[date.key] = value.integerValue
                        }
                    }
                }
            }
        })
        return dict
    }
    
    static func fetchLowCounts() -> [String : Int] {
        var dict: Dictionary = [String: Int]()
        
        Firebase.userRef.child("dates").queryLimited(toFirst: 5).observe(DataEventType.value, with: { (snapshot) in
            let enumerator = snapshot.children
            while let date = enumerator.nextObject() as? DataSnapshot {
                let secondEnumerator = date.children
                while let counter = secondEnumerator.nextObject() as? DataSnapshot {
                    if counter.key == "lowCounter" {
                        if let value = ((counter.value as? NSString)) {
                                  dict[date.key] = value.integerValue
                        }
                    }
                }
            }
        })
        return dict
    }
    
    static func incrementHighCounter() {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let string_day =  day < 10 ? "0" + String(day) : String(day)
        let string_month = month < 10 ? "0" + String(month) : String(month)
        let string_year = String(year)
        
        let today = string_month+string_day+string_year
        
//        Firebase.userRef.child("dates").child(today).child("highCounter").setValue(5)
//        Firebase.userRef.child("dates").child(today).child("lowCounter").setValue(6)
        
        Firebase.userRef.child("dates").child(today).child("highCounter").observe(DataEventType.value, with: { (snapshot) in
            let countRef = Firebase.userRef.child("dates").child(today).child("highCounter")
            
            guard let value = snapshot.value as? Int else {
                countRef.setValue(0)
                return
            }
            countRef.setValue(value+1)
        })
    }
    
    static func incrementLowCounter() {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let string_day =  day < 10 ? "0" + String(day) : String(day)
        let string_month = month < 10 ? "0" + String(month) : String(month)
        let string_year = String(year)
        
        let today = string_month+string_day+string_year
        
        Firebase.userRef.child("dates").child(today).child("lowCounter").observe(DataEventType.value, with: { (snapshot) in
            let countRef = Firebase.userRef.child("dates").child(today).child("lowCounter")
            
            guard let value = snapshot.value as? Int else {
                countRef.setValue(0)
                return
            }
            countRef.setValue(value+1)
        })
    }
    
    static func mealStatusChanged(callback: @escaping (DataSnapshot) -> Void) {
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        let string_day =  day < 10 ? "0" + String(day) : String(day)
        let string_month = month < 10 ? "0" + String(month) : String(month)
        let string_year = String(year)
        
        let today = string_month+string_day+string_year
        
        Firebase.userRef.child("dates").child(today).child("meal").observeSingleEvent(of: .childChanged, with: callback)
    }    
}




