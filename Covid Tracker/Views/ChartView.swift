//
//  pieChartView.swift
//  Covid Tracker
//
//  Created by Alley Pereira on 12/06/21.
//

import UIKit
import Charts

class ChartView: UIView {

    lazy var headerView = UIView(
        frame: CGRect(
            x: 0,
            y: 0,
            width: self.frame.size.width,
            height: self.frame.size.height)
    )

    func createGraph(dayData: [DayData]) {

        let chart = LineChartView(
            frame:
                CGRect(
                    x: 0,
                    y: 0,
                    width: self.frame.size.width,
                    height: self.frame.size.width/1.5
                )
        )

        chart.backgroundColor = UIColor.clear
        chart.gridBackgroundColor = UIColor.white
        chart.drawGridBackgroundEnabled = true
        chart.drawBordersEnabled = false
        chart.chartDescription?.enabled = false
        chart.pinchZoomEnabled = true
        chart.dragEnabled = true
        chart.setScaleEnabled(false)
        chart.legend.enabled = false
        chart.xAxis.enabled = true
        chart.leftAxis.drawAxisLineEnabled = false
        chart.rightAxis.enabled = false
        chart.data = nil

        var entries: [ChartDataEntry] = []
        let set = dayData.prefix(15)

        for index in 0..<set.count {
            let data = set[index]
            let entry = ChartDataEntry(x: Double(index), y: Double(data.count))
            entries.append(entry)
        }

        //        let dataSet = BarChartDataSet(entries: entries)
        //        let data: BarChartData = BarChartData(dataSet: dataSet)
        let dataSet = LineChartDataSet(entries: entries)
        dataSet.axisDependency = .left
        dataSet.setColor(UIColor(red: 255/255, green: 241/255, blue: 46/255, alpha: 1))
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 0
        dataSet.circleRadius = 3
        dataSet.fillAlpha = 1
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = .systemTeal
        dataSet.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        dataSet.drawCircleHoleEnabled = false
        dataSet.fillFormatter = DefaultFillFormatter { _,_  -> CGFloat in
            return CGFloat(chart.leftAxis.axisMinimum)
        }

        let data = LineChartData(dataSet: dataSet)

        dataSet.colors = ChartColorTemplates.joyful()

        chart.data = data

        headerView.addSubview(chart)
        headerView.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(headerView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
