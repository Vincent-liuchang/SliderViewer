//
//  PieChartCell.swift
//  OneApp
//
//  Created by viliu2 on 2023/9/9.
//

import SwiftUI
import Charts

@available(iOS 17.0, *)
struct PieChartCell: View {
    @State var data: [Record]
    var body: some View {
        Chart(data) {
            SectorMark(
                angle: .value("Value", $0.value),
                innerRadius: .ratio(0.618),
                outerRadius: .inset(10),
                angularInset: 1.5
            )
            .cornerRadius(3)
            .foregroundStyle(by: .value("name", $0.name))
        }
        .scaledToFit()
        .padding()
    }
}
