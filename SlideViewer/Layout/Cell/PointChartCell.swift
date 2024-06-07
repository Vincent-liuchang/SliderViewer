//
//  PointChartCell.swift
//  OneApp
//
//  Created by viliu2 on 2023/9/9.
//

import SwiftUI
import Charts

struct PointChartCell: View {
    @State var data: [Bill]
    var body: some View {
        Chart(data) {
            PointMark(
                x: .value("name", $0.name),
                y: .value("value", $0.value)
            )
            .foregroundStyle(by: .value("type", $0.categtory.rawValue))
        }
        .scaledToFit()
        .padding()
    }
}
