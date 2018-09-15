//
//  BarChartViewController.swift
//  better-belly
//
//  Created by Grazietta Hof on 2018-09-15.
//  Copyright © 2018 Ansar Khan. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController: UIViewController {
    
    override func viewDidLoad() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        
        let fakeData : [Date:Float] = [
            formatter.date(from: "09/15")! : 60,
            formatter.date(from: "09/16")! : 70,
            formatter.date(from: "09/17")! : 80,
            formatter.date(from: "09/18")! : 60,
            formatter.date(from: "09/15")! : 10
        ]
        
        super.viewDidLoad()
    }
    
}
