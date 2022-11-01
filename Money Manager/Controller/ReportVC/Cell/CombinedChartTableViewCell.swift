//
//  CombinedChartTableViewCell.swift
//  Money Manager
//
//  Created by MAC on 11/1/22.
//

import UIKit
import Charts

class CombinedChartTableViewCell: UITableViewCell {
    static let identifier = "CombinedChartTableViewCell"
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var chartNameLabel: UILabel!
    @IBOutlet weak var chartBar: CombinedChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        chartBar.setExtraOffsets(left: 20, top: 0, right: 20, bottom: 0)
    }
    
    // MARK: Set Combined Chart
    func setCombinedChart(_ xValues: [String], _ yValuesLineChart: [Int], _ yValuesBarChart: [Int], _ chartView: CombinedChartView) {
        chartView.noDataText = "Please provide data for the chart."
        
        var yValuesLine: [ChartDataEntry] = [ChartDataEntry]()
        var yValuesBar: [BarChartDataEntry] = [BarChartDataEntry]()
        
        for i in 0..<xValues.count {
            yValuesLine.append(ChartDataEntry(x: Double(i), y: Double(yValuesLineChart[i])))
            yValuesBar.append(BarChartDataEntry(x: Double(i), y: Double(yValuesBarChart[i])))
        }
        
        let lineChartSet = LineChartDataSet(entries: yValuesLine, label: "Expense")
        lineChartSet.colors = [NSUIColor(red: 64/255.0, green: 89/255.0, blue: 128/255.0, alpha: 1.0)]
        lineChartSet.circleColors = [NSUIColor(red: 64/255.0, green: 89/255.0, blue: 128/255.0, alpha: 1.0)]
        lineChartSet.drawCirclesEnabled = true
        lineChartSet.circleRadius = 4
        lineChartSet.mode = .horizontalBezier
        lineChartSet.axisDependency = .left
        
        lineChartSet.lineWidth = 2
        let barChartSet = BarChartDataSet(entries: yValuesBar, label: "Income")
        barChartSet.colors = [NSUIColor(red: 149/255.0, green: 165/255.0, blue: 124/255.0, alpha: 1.0)]
        
        let data = CombinedChartData()
        data.barData = BarChartData(dataSet: barChartSet)
        data.lineData = LineChartData(dataSet: lineChartSet)
        
        chartView.data = data
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.yOffset = -20
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        chartView.xAxis.granularity = 1
        chartView.animate(xAxisDuration: 5, yAxisDuration: 5, easingOption: .easeOutBack)
        //        chartView.xAxis.labelRotationAngle = -90
        chartView.xAxis.setLabelCount(xValues.count, force: false)
        chartView.legend.enabled = false
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "vi_VN")
        formatter.groupingSeparator = "."
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.setValueTextColor(.black)
    }
}
