//
//  Ruller.swift
//  SlideViewer
//
//  Created by Chang Liu on 25/5/2024.
//

import SwiftUI
import UIKit
import SwiftyRuler

struct HorizontalSwiftRuler: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let ruler: Ruler = {
            let ruler = Ruler()
            ruler.longTickLength = 25
            ruler.shortTickLength = 10
            ruler.midTickLength = ruler.midLineLength(2)
            ruler.pixelAccurate = true
            ruler.doubleUnits = true
            ruler.accuracyWarnings = true
            return ruler
        }()
        ruler.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        ruler.tickColor = .white
        ruler.labelColor = .white
        return ruler
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

struct VerticalSwiftRuler: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let ruler: Ruler = {
            let ruler = Ruler()
            ruler.longTickLength = 30
            ruler.shortTickLength = 10
            ruler.midTickLength = ruler.midLineLength(2)
            ruler.pixelAccurate = true
            ruler.doubleUnits = true
            ruler.accuracyWarnings = true
            ruler.direction = .vertical
            return ruler
        }()
        ruler.backgroundColor = UIColor.label.withAlphaComponent(0.05)
        ruler.tickColor = .label
        ruler.labelColor = .label
        return ruler
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
