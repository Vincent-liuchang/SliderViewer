//
//  LineChartCell.swift
//  OneApp
//
//  Created by viliu2 on 2023/9/7.
//

import SwiftUI
import Charts

struct LineChartCell: View {
    @State var data: [Record]
    var body: some View {
        Chart(data) {
            LineMark(
                x: .value("month", $0.name),
                y: .value("value", $0.value)
            )
            .foregroundStyle(by: .value("type", $0.type))
        }
        .scaledToFit()
        .padding()
    }
}
