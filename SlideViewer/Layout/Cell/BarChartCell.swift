//
//  BarChartCell.swift
//  OneApp
//
//  Created by viliu2 on 2023/9/7.
//

import SwiftUI
import Charts

struct BarChartCell: View {
    @State var data: [Record]
    var body: some View {
        Chart(data) {
            BarMark(
                x: .value("name", $0.name),
                y: .value("Profit", $0.value)
            )
            .foregroundStyle(by: .value("type", $0.type))
        }
        .scaledToFit()
        .padding()
    }
}
