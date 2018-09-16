//
//  BarChartViewController.swift
//  better-belly
//
//  Created by Grazietta Hof on 2018-09-15.
//  Copyright © 2018 Ansar Khan. All rights reserved.
//

import UIKit
import Charts

class BarChartViewController : UIViewController {
    
    
    @IBOutlet var barChartView: BarChartView!
    
    override func viewDidLoad() {
        
        let barSpace = 0.05
        let barWidth = 0.3
        let groupSpace = 0.3
        
        let fakeDataHigh : [Double:Double] = [
            15 : 60,
            16 : 70,
            17 : 80,
            18 : 20,
            19 : 10
        ]
        
        let fakeDataLow : [Double:Double] = [
            15 : 40,
            16 : 30,
            17 : 20,
            18 : 80,
            19 : 90
        ]
        
        super.viewDidLoad()        
       // barChartView.chartDescription?.text
        
        var highDataEntries: [BarChartDataEntry] = []
        var lowDataEntries: [BarChartDataEntry] = []
        
        fakeDataHigh.forEach { (element) in
            highDataEntries.append(BarChartDataEntry(x: element.key, y: element.value))
        }
        
        fakeDataLow.forEach { (element) in
            lowDataEntries.append(BarChartDataEntry(x: element.key, y: element.value))
        }
        
        let chartDataSetHigh = BarChartDataSet(values: highDataEntries, label: "High")
        let chartDataSetLow = BarChartDataSet(values: lowDataEntries, label: "Low")
        
        chartDataSetLow.colors = [UIColor(red: 130/255, green: 201/255, blue: 185/255, alpha: 1)]
        chartDataSetHigh.colors = [UIColor(red: 118/255, green: 119/255, blue: 119/255, alpha: 1)]
        
        let chartData = BarChartData(dataSets: [chartDataSetLow, chartDataSetHigh])
        chartData.barWidth = barWidth
        chartData.groupBars(fromX: Double(15), groupSpace: groupSpace, barSpace: barSpace)
        barChartView.notifyDataSetChanged()
        
        barChartView.data = chartData
        barChartView.backgroundColor = .white
        
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    }
}
